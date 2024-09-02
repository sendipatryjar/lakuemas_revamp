import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/input_formater/uppercase_input_formater.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../data/models/elite_register_req.dart';
import 'blocs/elite_blocs.dart';
import 'cubits/elite_cubits.dart';

class EliteCodeReferalScreen extends StatefulWidget {
  final EliteRegisterReq? eliteRegisterReq;
  const EliteCodeReferalScreen({
    super.key,
    this.eliteRegisterReq,
  });

  @override
  State<EliteCodeReferalScreen> createState() => _EliteCodeReferalScreenState();
}

class _EliteCodeReferalScreenState extends State<EliteCodeReferalScreen> {
  late TextEditingController referalCodeTec;

  @override
  void initState() {
    super.initState();
    referalCodeTec = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<EliteReferalValidationBloc>()),
        BlocProvider(create: (context) => sl<EliteReferalValidationCubit>()),
        BlocProvider(create: (context) => sl<EliteCubit>())
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: clrBackgroundBlack,
          centerTitle: true,
          title: Text(
            t.lblRegistLakuemasElite,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: MainBackButton(
            onPressed: () {
              context.goNamed(AppRoutes.elite);
            },
          ),
        ),
        bottomNavigationBar: _mainButton(context, referalCodeTec),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: BlocBuilder<EliteReferalValidationCubit,
              EliteReferalValidationCubitState>(
            builder: (context, state) {
              return MainTextField(
                controller: referalCodeTec,
                title: t.lblReferalCode,
                titleColor: clrDarkBlue,
                isDarkMode: false,
                isUppercase: true,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')),
                  UpperCaseInputFormatter(),
                ],
                isError: state.isReferalError ?? false,
                errorText: state.referalErrorMessages,
                onChange: (value) {
                  context
                      .read<EliteReferalValidationCubit>()
                      .validate(t: t, referalCode: referalCodeTec.text);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Container _mainButton(
      BuildContext context, TextEditingController referalCodeTec) {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child:
          BlocConsumer<EliteReferalValidationBloc, EliteReferalValidationState>(
        listener: (context, state) {
          if (state is EliteReferalValidationLoadingState) {
            EasyLoading.show();
          }

          if (state is EliteReferalValidationSuccessState) {
            EasyLoading.dismiss();
            if (state.eliteReferalValidaitonEntity.isValid == true) {
              DialogUtils.success(
                context: context,
                barrierDismissible: true,
                firstDescWidget: Text.rich(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: clrWhite,
                    ),
                    children: [
                      const TextSpan(text: "Selamat! Kode referal"),
                      TextSpan(
                        text:
                            " ${state.eliteReferalValidaitonEntity.referalName ?? '-'} ",
                        style: TextStyle(
                          color: clrYellow,
                        ),
                      ),
                      const TextSpan(text: "berhasil kamu gunakan"),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                secondDesc: t.lblSuccessReferalDesc,
                btnText: t.lblContinue,
                btnOnPressed: () {
                  widget.eliteRegisterReq?.copyWith(
                    referalCode: referalCodeTec.text,
                  );
                  context.goNamed(
                    AppRoutes.eliteSubscriptionMethod,
                    extra: {
                      'eliteRegisterReq':
                          EliteRegisterReq(referalCode: referalCodeTec.text),
                      'eliteCubit': context.read<EliteCubit>(),
                      'backScreen': AppRoutes.eliteReferal,
                    },
                    // extra: EliteRegisterReq(referalCode: referalCodeTec.text),
                  );
                },
              );
            }

            if (state.eliteReferalValidaitonEntity.isValid == false) {
              DialogUtils.failure(
                context: context,
                barrierDismissible: true,
                firstDesc: t.lblFailureReferalTitle,
                secondDesc: t.lblFailureReferalDesc,
                btnText: t.lblBack,
                btnOnPressed: () {
                  context.pop();
                },
              );
            }
          }

          if (state is EliteReferalValidationFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
            Future.delayed(const Duration(seconds: 2)).then((value) {
              context.goNamed(AppRoutes.elite);
            });
          }
        },
        builder: (context, state) {
          return MainButton(
            label: t.lblCheck,
            onPressed: () {
              context
                  .read<EliteReferalValidationCubit>()
                  .validate(t: t, referalCode: referalCodeTec.text);
              final isValid =
                  context.read<EliteReferalValidationCubit>().isValid;
              if (isValid) {
                context.read<EliteReferalValidationBloc>().add(
                    EliteReferalValidationSuccessEvent(referalCodeTec.text));
              }
            },
          );
        },
      ),
    );
  }
}
