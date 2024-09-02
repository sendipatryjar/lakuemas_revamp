import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../beranda/presentation/blocs/balance/balance_bloc.dart';
import 'blocs/lakusave_checkout/lakusave_checkout_bloc.dart';
import 'blocs/master_data/master_data_lakusave_bloc.dart';
import 'cubits/laku_save_terms_condition/laku_save_terms_condition_cubit.dart';
import 'cubits/lakusave/lakusave_cubit.dart';
import 'widgets/laku_save_checkbox.dart';

class LakuSaveDetailScreen extends StatelessWidget {
  final bool isValidated;
  const LakuSaveDetailScreen({super.key, this.isValidated = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<LakuSaveTermsConditionCubit>()),
        isValidated
            ? BlocProvider(create: (context) {
                final lkSaveCbtState = context.read<LakusaveCubit>().state;
                final berandaBalanceBlocState = (context
                    .read<BerandaBalancesBloc>()
                    .state as BerandaBalancesSuccessState);
                return sl<LakusaveCheckoutBloc>()
                  ..add(LakusaveCheckoutDoNowEvent(
                    durationId: lkSaveCbtState.selectedDurationEntity?.id,
                    extendedId: lkSaveCbtState.selectedExtendedEntity?.id,
                    goldWeight: lkSaveCbtState.goldAmount,
                    accountNumber: berandaBalanceBlocState
                        .goldBalanceEntity?.accountNumber,
                    accountNumberDest: berandaBalanceBlocState
                        .goldBalanceEntity?.accountNumber,
                  ));
              })
            : BlocProvider(create: (context) => sl<LakusaveCheckoutBloc>()),
      ],
      child: BlocListener<LakusaveCheckoutBloc, LakusaveCheckoutState>(
        listener: (context, state) {
          if (state is LakusaveCheckoutLoadingState) {
            EasyLoading.show();
          }
          if (state is LakusaveCheckoutSuccessState) {
            context.read<HelperDataCubit>().resetDataAfterTrx();
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.lakuSave,
              extra: {
                'isElite': context.read<EliteCubit>().state.toString(),
                'berandaBalancesBloc': context.read<BerandaBalancesBloc>(),
              },
            );
          }
          if (state is LakusaveCheckoutFailureState) {
            EasyLoading.dismiss();
            if (state.appFailure is ServerFailure) {
              return;
            }
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: const _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final scrollController = ScrollController();
    var lkSaveCbtState = context.read<LakusaveCubit>().state;
    var berandaBalanceBlocState = (context.read<BerandaBalancesBloc>().state
        as BerandaBalancesSuccessState);
    var masterDataLakusaveBlocState = (context
        .read<MasterDataLakusaveBloc>()
        .state as MasterDataLakusaveSuccessState);

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocBuilder<LakusaveCheckoutBloc, LakusaveCheckoutState>(
          builder: (context, state) {
            if (state is LakusaveCheckoutFailureState) {
              if (state.appFailure is ServerFailure) {
                return Scaffold(
                  backgroundColor: isElite ? clrBlack080 : null,
                  appBar: AppBar(
                    backgroundColor: clrBlack101,
                    title: Text(
                      "Error",
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                    ),
                    centerTitle: true,
                    leading: MainBackButton(
                      onPressed: () {
                        context
                            .read<LakusaveCheckoutBloc>()
                            .add(LakusaveCheckoutInitEvent());
                      },
                    ),
                  ),
                  body: ServerErrorScreen(
                    onTryAgainPressed: () {
                      context
                          .read<LakusaveCheckoutBloc>()
                          .add(LakusaveCheckoutDoNowEvent(
                            durationId:
                                lkSaveCbtState.selectedDurationEntity?.id,
                            extendedId:
                                lkSaveCbtState.selectedExtendedEntity?.id,
                            goldWeight: lkSaveCbtState.goldAmount,
                            accountNumber: berandaBalanceBlocState
                                .goldBalanceEntity?.accountNumber,
                            accountNumberDest: berandaBalanceBlocState
                                .goldBalanceEntity?.accountNumber,
                          ));
                    },
                  ),
                );
              }
            }
            return Scaffold(
              backgroundColor: isElite ? clrBlack080 : null,
              appBar: AppBar(
                backgroundColor: clrBlack101,
                centerTitle: true,
                title: Text(
                  t.lblLakuSave,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: MainBackButton(
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20),
                child: MainButton(
                  label: t.lblDeposit,
                  onPressed: () {
                    _showBottomSheet(context,
                        isElite: isElite,
                        scrollController: scrollController,
                        title: masterDataLakusaveBlocState.goldDepositEntity
                                ?.termsAndConditionsEntity?.title ??
                            '-',
                        htmlData: masterDataLakusaveBlocState.goldDepositEntity
                                ?.termsAndConditionsEntity?.description ??
                            '', onTap: () {
                      context.goNamed(
                        AppRoutes.pin,
                        extra: {
                          'pinType': '${PinType.validate}',
                          'backScreenPin': AppRoutes.lakuSaveDetail,
                          'nextScreenPin': AppRoutes.lakuSaveDetail,
                          'eliteCubit': context.read<EliteCubit>(),
                          'berandaBalancesBloc':
                              context.read<BerandaBalancesBloc>(),
                          'lakusaveCubit': context.read<LakusaveCubit>(),
                          'masterDataLakusaveBloc':
                              context.read<MasterDataLakusaveBloc>(),
                        },
                      );
                    });
                  },
                ),
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        t.lblDetailLakuDepo,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isElite
                              ? clrGreyE5e.withOpacity(0.12)
                              : clrGreyE5e.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            width: 2,
                            color: clrNeutralGrey999.withOpacity(0.16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.lblSourceFunds,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                color: isElite
                                    ? clrWhite.withOpacity(0.75)
                                    : clrBackgroundBlack.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              t.lblMainAccount,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              berandaBalanceBlocState
                                      .goldBalanceEntity?.accountNumber ??
                                  '-',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              height: 1,
                              width: double.infinity,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                            ...[
                              Text(
                                t.lblWeightGold,
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isElite
                                      ? clrWhite.withOpacity(0.75)
                                      : clrBackgroundBlack.withOpacity(0.75),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${lkSaveCbtState.goldAmount ?? '-'} gram',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isElite ? clrWhite : clrBackgroundBlack,
                                ),
                              ),
                            ],
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              height: 1,
                              width: double.infinity,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                            Text(
                              t.lblCustodyPeriod,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                color: isElite
                                    ? clrWhite.withOpacity(0.75)
                                    : clrBackgroundBlack.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${lkSaveCbtState.selectedDurationEntity?.duration ?? ''} ${t.lblMonths}',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              height: 1,
                              width: double.infinity,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                            Text(
                              t.lblCapitalLease,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                color: isElite
                                    ? clrWhite.withOpacity(0.75)
                                    : clrBackgroundBlack.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${lkSaveCbtState.selectedInterestEntity?.interest ?? '-'}% per tahun',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              height: 1,
                              width: double.infinity,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                            ...[
                              Text(
                                t.lblRenewalAccNumber,
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isElite
                                      ? clrWhite.withOpacity(0.75)
                                      : clrBackgroundBlack.withOpacity(0.75),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lkSaveCbtState.userDataEntity?.name ?? '-',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isElite ? clrWhite : clrBackgroundBlack,
                                ),
                              ),
                              Text(
                                berandaBalanceBlocState
                                        .goldBalanceEntity?.accountNumber ??
                                    '-',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isElite ? clrWhite : clrBackgroundBlack,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBottomSheet(
    BuildContext context, {
    bool isElite = false,
    ScrollController? scrollController,
    String? title,
    String? htmlData,
    Function()? onTap,
  }) {
    showModalBottomSheet(
      // expand: true,
      isScrollControlled: true,
      context: context,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<LakuSaveTermsConditionCubit>(),
        child: _contentBottomSheet(
          context,
          isElite: isElite,
          scrollController: scrollController,
          title: title,
          htmlData: htmlData,
          onTap: onTap,
        ),
      ),
    ).then((value) => context
        .read<LakuSaveTermsConditionCubit>()
        .updateTermsConditions(false));
  }

  Widget _contentBottomSheet(
    BuildContext context, {
    bool isElite = false,
    ScrollController? scrollController,
    String? title,
    String? htmlData,
    Function()? onTap,
  }) {
    return FractionallySizedBox(
      heightFactor: 0.88,
      child: Container(
        decoration: BoxDecoration(
          color: isElite ? clrBlack080 : clrWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                title ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              color: clrNeutralGrey999.withOpacity(0.16),
              height: 1,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(
                        data: htmlData,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            // fontSize: FontSize(12),
                            // lineHeight:
                            //     const LineHeight(2.5),
                            color: (isElite ? clrWhite : clrBackgroundBlack)
                                .withOpacity(0.75),
                          )
                        },
                      ),
                      const SizedBox(height: 32),
                      LakuSaveCheckbox(
                        scrollController: scrollController!,
                        isElite: isElite,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<LakuSaveTermsConditionCubit,
                  LakuSaveTermsConditionState>(
                builder: (context, state) {
                  return MainButton(
                    label: 'Depositkan',
                    onPressed: (state.isTermsConditionsChecked == true)
                        ? () {
                            if (onTap != null) onTap();
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
