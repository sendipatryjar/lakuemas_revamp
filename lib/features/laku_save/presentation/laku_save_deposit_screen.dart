import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_dropdown.dart';
import '../../beranda/presentation/blocs/balance/balance_bloc.dart';
import '../domain/entities/lakusave_duration_entity.dart';
import 'blocs/master_data/master_data_lakusave_bloc.dart';
import 'cubits/lakusave/lakusave_cubit.dart';
import 'widgets/laku_save_balance_widget.dart';

class LakuSaveDepositScreen extends StatelessWidget {
  const LakuSaveDepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<LakusaveCubit>()..getUserData(),
        ),
        // BlocProvider(
        //   create: (context) =>
        //       sl<MasterDataLakusaveBloc>()..add(MasterDataLakusaveGetEvent()),
        // ),
      ],
      child: const _Content(),
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
    final goldGramTec = TextEditingController();

    context.read<BerandaBalancesBloc>().add(BerandaBalancesGetEvent(
        helperDataCubit: context.read<HelperDataCubit>()));

    String? currGoldBalance;
    var bBalanceBloc = context.watch<BerandaBalancesBloc>();
    if (bBalanceBloc.state is BerandaBalancesSuccessState) {
      currGoldBalance = (context.watch<BerandaBalancesBloc>().state
              as BerandaBalancesSuccessState)
          .goldBalanceEntity
          ?.gramationBalance;
    }

    String? minGoldAmount;
    var masterDatBlocState = context.watch<MasterDataLakusaveBloc>().state;
    if (masterDatBlocState is MasterDataLakusaveSuccessState) {
      minGoldAmount = context.read<EliteCubit>().state
          ? (masterDatBlocState.goldDepositEntity?.eliteMinimumBalance ?? '')
          : (masterDatBlocState.goldDepositEntity?.minimumBalance ?? '-');
    }

    goldGramTec.addListener(() {
      appPrint('goldGramTec: ${goldGramTec.text}');
      final lakusaveCbtState = context.read<LakusaveCubit>().state;
      context.read<LakusaveCubit>().selectInterest(
            interests: (context.read<MasterDataLakusaveBloc>().state
                        as MasterDataLakusaveSuccessState)
                    .goldDepositEntity
                    ?.interests ??
                [],
            customerTypeId: lakusaveCbtState.userDataEntity?.customerTypeId,
            durationId: lakusaveCbtState.selectedDurationEntity?.id,
            goldAmount: double.tryParse(goldGramTec.text.toGold4Dec()) ?? 0,
            minGoldAmount: double.tryParse(minGoldAmount ?? ''),
            userGoldBalance: double.tryParse(currGoldBalance ?? ''),
            isElite: context.read<EliteCubit>().state,
          );
    });

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<MasterDataLakusaveBloc, MasterDataLakusaveState>(
              builder: (context, state) {
                String minGramation = '-';
                if (state is MasterDataLakusaveSuccessState) {
                  minGramation = isElite
                      ? (state.goldDepositEntity?.eliteMinimumBalance ?? '')
                      : (state.goldDepositEntity?.minimumBalance ?? '-');
                }
                return MainButton(
                  label: t.lblContinue,
                  onPressed: context.watch<LakusaveCubit>().isValidated(
                          double.tryParse(minGramation),
                          double.parse(currGoldBalance ?? '0'))
                      ? () {
                          context.goNamed(
                            AppRoutes.lakuSaveAutoDeposit,
                            extra: {
                              'isElite': isElite.toString(),
                              'berandaBalancesBloc':
                                  context.read<BerandaBalancesBloc>(),
                              'lakusaveCubit': context.read<LakusaveCubit>(),
                              'masterDataLakusaveBloc':
                                  context.read<MasterDataLakusaveBloc>(),
                            },
                          );
                        }
                      : null,
                );
              },
            ),
          ),
          body: Column(
            children: [
              LakuSaveBalanceWidget(isElite: isElite),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sourceFund(context, isElite: isElite),
                        const SizedBox(height: 20),
                        Text(
                          t.lblDetailDeposit,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isElite
                                ? clrGreyE5e.withOpacity(0.12)
                                : clrGreyE5e.withOpacity(0.25),
                            border: Border.all(
                              width: 2,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.lblWeightGold,
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isElite ? clrWhite : clrBackgroundBlack,
                                ),
                              ),
                              const SizedBox(height: 6),
                              BlocBuilder<MasterDataLakusaveBloc,
                                  MasterDataLakusaveState>(
                                builder: (context, state) {
                                  String minGramation = '-';
                                  if (state is MasterDataLakusaveSuccessState) {
                                    minGramation = isElite
                                        ? (state.goldDepositEntity
                                                ?.eliteMinimumBalance ??
                                            '')
                                        : (state.goldDepositEntity
                                                ?.minimumBalance ??
                                            '-');
                                  }
                                  return Text(
                                    context
                                            .read<LakusaveCubit>()
                                            .state
                                            .isAmountMoreThanBalance
                                        ? t.lblGoldBalanceNotEnough
                                        : t.lblMinimumAmount(minGramation),
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: (context
                                                  .watch<LakusaveCubit>()
                                                  .state
                                                  .isErrorGoldAmount ==
                                              true)
                                          ? clrRed
                                          : isElite
                                              ? clrWhite.withOpacity(0.75)
                                              : clrBackgroundBlack
                                                  .withOpacity(0.75),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              _goldInputField(
                                isElite,
                                currGoldBalance,
                                goldGramTec,
                                t,
                                context,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '${t.lblSelect} ${t.lblCustodyPeriod}',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isElite ? clrWhite : clrBackgroundBlack,
                                ),
                              ),
                              const SizedBox(height: 16),
                              BlocBuilder<MasterDataLakusaveBloc,
                                  MasterDataLakusaveState>(
                                builder: (context, state) {
                                  if (state is MasterDataLakusaveLoadingState) {
                                    return Shimmer.fromColors(
                                      baseColor: clrGreyShimmerBase,
                                      highlightColor: clrGreyShimmerHighlight,
                                      child: Container(
                                        width: double.infinity,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: clrWhite,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                    );
                                  }
                                  if (state is MasterDataLakusaveSuccessState) {
                                    var items =
                                        (state.goldDepositEntity?.durations ??
                                            []);
                                    return MainDropDown<LakusaveDurationEntity>(
                                      hintText:
                                          '${t.lblSelect} ${t.lblCustodyPeriod}',
                                      items: items,
                                      itemName: (val) =>
                                          '${val.duration} ${t.lblMonths}',
                                      value: context
                                          .read<LakusaveCubit>()
                                          .state
                                          .selectedDurationEntity,
                                      onChange: (value) => context
                                          .read<LakusaveCubit>()
                                          .changeDuration(
                                            interests: state.goldDepositEntity
                                                    ?.interests ??
                                                [],
                                            customerTypeId: context
                                                .read<LakusaveCubit>()
                                                .state
                                                .userDataEntity
                                                ?.customerTypeId,
                                            value: value,
                                            goldAmount: double.tryParse(
                                                goldGramTec.text),
                                            userGoldBalance: double.tryParse(
                                                currGoldBalance ?? ''),
                                            isElite: isElite,
                                          ),
                                      isElite: isElite,
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _goldInputField(
    bool isElite,
    String? currGoldBalance,
    TextEditingController goldGramTec,
    AppLocalizations t,
    BuildContext context,
  ) {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: BoxDecoration(
        color: (context.watch<LakusaveCubit>().state.isErrorGoldAmount == true)
            ? clrRed.withOpacity(0.25)
            : clrGreyE5e.withOpacity(0.25),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 2,
          color: context.watch<LakusaveCubit>().state.isErrorGoldAmount == true
              ? clrRed.withOpacity(0.10)
              : clrNeutralGrey999.withOpacity(0.16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                controller: goldGramTec,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: (isElite ? clrWhite : clrBackgroundBlack)
                        .withOpacity(0.5),
                  ),
                  labelText: t.lblFillGram,
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: (isElite ? clrWhite : clrBackgroundBlack)
                        .withOpacity(0.5),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
                  FilteringTextInputFormatter.deny(
                    RegExp(r'^\.+'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                // vertical: 7,
              ),
              decoration: BoxDecoration(
                color:
                    ((context.watch<LakusaveCubit>().state.isErrorGoldAmount ==
                                true)
                            ? clrRed
                            : clrNeutralGrey999)
                        .withOpacity(0.16),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.lblYouGet,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: (isElite ? clrWhite : clrBackgroundBlack)
                          .withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    text: TextSpan(
                      text: (context
                                  .watch<LakusaveCubit>()
                                  .state
                                  .selectedInterestEntity
                                  ?.interest ??
                              0)
                          .toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                      children: [
                        TextSpan(
                          text: ' % Per Tahun',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _sourceFund(BuildContext context, {required bool isElite}) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.lblSourceFunds,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isElite
                ? clrGreyE5e.withOpacity(0.12)
                : clrGreyE5e.withOpacity(0.25),
            border: Border.all(
              width: 2,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.lblMainAccount,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              const SizedBox(height: 4),
              BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
                builder: (context, state) {
                  String accountNumber = '-';
                  if (state is BerandaBalancesSuccessState) {
                    accountNumber =
                        state.goldBalanceEntity?.accountNumber ?? '-';
                  }
                  return Text(
                    accountNumber,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _depoTime({
  //   required bool isElite,
  //   required String title,
  //   bool isSelected = false,
  //   Function()? onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? isElite
  //                 ? clrWhite
  //                 : clrBackgroundBlack
  //             : clrNeutralGrey999.withOpacity(0.16),
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       alignment: Alignment.center,
  //       child: Text(
  //         title,
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
  //           color: isSelected
  //               ? (isElite ? clrBackgroundBlack : clrWhite)
  //               : (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
