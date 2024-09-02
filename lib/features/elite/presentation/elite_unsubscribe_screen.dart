import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../features/elite/presentation/blocs/unsub_elite/unsub_elite_bloc.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import 'cubits/elite_unsub_validation/elite_unsub_validation_cubit.dart';

class EliteUnsubscribeScreen extends StatelessWidget {
  const EliteUnsubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final TextEditingController reasonUnsubTec = TextEditingController();
    final reasons = [
      'Biayanya terlalu mahal',
      'Saya menemukan layanan di app lain',
      'Fiturnya tidak sesuai dengan kebutuhan',
      'Layanan bermasalah',
      'Alasan lainnya (wajib ditulis)'
    ];
    const reasonOtherStr = 'Alasan lainnya (wajib ditulis)';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<EliteUnsubValidationCubit>()..updateReasonCb(reasonOtherStr),
        ),
        BlocProvider(
          create: (context) => sl<UnsubEliteBloc>(),
        ),
      ],
      child: BlocListener<UnsubEliteBloc, UnsubEliteState>(
        listener: (context, state) {
          if (state is UnsubEliteLoadingState) {
            EasyLoading.show();
          }

          if (state is UnsubEliteSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(AppRoutes.eliteUnsubscribeSuccess);
          }

          if (state is UnsubEliteFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: BlocBuilder<EliteCubit, bool>(
          builder: (context, isElite) {
            return Scaffold(
              backgroundColor: isElite ? clrBlack080 : null,
              appBar: AppBar(
                backgroundColor: clrBackgroundBlack,
                centerTitle: true,
                elevation: 0,
                title: Text(
                  t.lblUnsubscribe,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: MainBackButton(
                  onPressed: () {
                    context.goNamed(
                      AppRoutes.elite,
                      extra: {'isElite': isElite.toString()},
                    );
                  },
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20),
                child: BlocBuilder<EliteUnsubValidationCubit,
                    EliteUnsubValidationState>(
                  builder: (context, state) {
                    return MainButton(
                      label: t.lblUnsubscribe,
                      onPressed: () {
                        context
                            .read<EliteUnsubValidationCubit>()
                            .validate(t: t, reasonUnsub: reasonUnsubTec.text);
                        final isValid =
                            context.read<EliteUnsubValidationCubit>().isValid;
                        if (isValid) {
                          DialogUtils.confirm(
                            context: context,
                            barrierDismissible: true,
                            firstDesc: t.lblSendReasonTitle,
                            btnText: t.lblYesUnsub,
                            btnConfirm: () {
                              context.read<UnsubEliteBloc>().add(
                                  UnsubElitePostEvent(
                                      reason: reasonUnsubTec.text));
                            },
                            btnTextLater: t.lblBack,
                            btnLater: () {
                              context.pop();
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kenapa kamu memutuskan berhenti berlanggan Lakuemas Elite?',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: clrWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: reasons
                            .map(
                              (e) => Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    e,
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: clrWhite.withOpacity(0.75),
                                    ),
                                  )),
                                  BlocBuilder<EliteUnsubValidationCubit,
                                      EliteUnsubValidationState>(
                                    builder: (context, state) {
                                      return Radio<String?>(
                                        value: e,
                                        groupValue: state.reasonUnsubMessagesCb,
                                        onChanged: (value) {
                                          if (value == reasonOtherStr) {
                                            reasonUnsubTec.text = '';
                                          } else {
                                            reasonUnsubTec.text = value ?? '';
                                          }
                                          context
                                              .read<EliteUnsubValidationCubit>()
                                              .updateReasonCb(value);
                                        },
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => (isElite
                                                        ? clrWhite
                                                        : clrBackgroundBlack)
                                                    .withOpacity(0.75)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      BlocBuilder<EliteUnsubValidationCubit,
                          EliteUnsubValidationState>(
                        builder: (context, state) {
                          if (state.reasonUnsubMessagesCb != reasonOtherStr) {
                            return const SizedBox();
                          }
                          return MainTextField(
                            controller: reasonUnsubTec,
                            hintText: 'Saya berhenti karena...',
                            isAddress: true,
                            isDarkMode: true,
                            maxLength: 150,
                            onChange: (value) {
                              context
                                  .read<EliteUnsubValidationCubit>()
                                  .validate(
                                      t: t, reasonUnsub: reasonUnsubTec.text);
                            },
                            isError: state.isReasonUnsubError ?? false,
                            errorText: state.reasonUnsubMessages,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 1.5,
                            color: clrNeutralGrey999.withOpacity(0.16),
                          ),
                          color: clrYellow.withOpacity(0.16),
                        ),
                        child: Row(
                          children: [
                            Image.asset(icWarningOrange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                t.lblWarnUnsub,
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: clrWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
