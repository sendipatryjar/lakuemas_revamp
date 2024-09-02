import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_banner.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import 'blocs/close_account/close_account_bloc.dart';
import 'cubits/cubit/close_account_validation_cubit.dart';

class CloseMyAccountScreen extends StatelessWidget {
  const CloseMyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CloseAccountBloc>()),
        BlocProvider(create: (context) => sl<CloseAccountValidationCubit>()),
      ],
      child: BlocListener<CloseAccountBloc, CloseAccountState>(
        listener: (context, state) {
          if (state is CloseAccountLoadingState) {
            EasyLoading.show();
          }
          if (state is CloseAccountSuccessState) {
            EasyLoading.dismiss();
            // Future.delayed(const Duration(seconds: 2)).then((value) {
            //   context.goNamed(AppRoutes.profile);
            // });
            DialogUtils.success(
              context: context,
              barrierDismissible: false,
              firstDesc: '${t.lblCloseAccount} ${t.lblSuccess}',
              btnText: 'Oke',
              btnOnPressed: () {
                context.goNamed(AppRoutes.profile);
              },
            );
          }
          if (state is CloseAccountFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(t: t),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  _Content({
    Key? key,
    required this.t,
  }) : super(key: key);

  final _reasonTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblCloseAccount,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.closeAccount);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MainButton(
          label: 'Submit',
          onPressed: () {
            // bool isValidated = _reasonTec.text.isNotEmpty;

            context
                .read<CloseAccountValidationCubit>()
                .validate(_reasonTec.text);

            final isValidated =
                context.read<CloseAccountValidationCubit>().isValid;

            if (isValidated) {
              context
                  .read<CloseAccountBloc>()
                  .add(CloseAccountSubmitEvent(_reasonTec.text));
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                '${t.lblReasonClosingAccount} (${t.lblRequired})',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: clrDarkBlue,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<CloseAccountValidationCubit,
                  CloseAccountValidationState>(
                builder: (context, state) {
                  return MainTextField(
                    controller: _reasonTec,
                    isAddress: true,
                    hintText: t.lblWhyCloseAccount,
                    maxLines: 6,
                    maxLength: 200,
                    isDarkMode: false,
                    onChange: (value) {
                      context
                          .read<CloseAccountValidationCubit>()
                          .validate(_reasonTec.text);
                    },
                    isError: state.isClsAccError ?? false,
                    errorText: state.isClsAccErrorMessage ?? '',
                  );
                },
              ),
              const SizedBox(height: 24),
              MainBanner(
                bgColor: clrYellow.withOpacity(0.16),
                content: Row(
                  children: [
                    Image.asset(icWarningOrange),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        t.lblAccountDeletedCantRecovered,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: clrBackgroundBlack,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
