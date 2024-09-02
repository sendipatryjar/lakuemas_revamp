import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/extensions/currency_extension.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/input_formater/currency_input_formater.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_grid_view.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../_core/user/domain/entities/balance_entity.dart';
import 'blocs/bank_me/bank_me_bloc.dart';
import 'blocs/withdrawal_pricing/withdrawal_pricing_bloc.dart';
import 'cubits/cash_withdrawal/cash_withdrawal_cubit.dart';
import 'widgets/account_balance_top_widget.dart';
import 'widgets/cash_withdrawal_info_widget.dart';

class CashWithdrawalScreen extends StatelessWidget {
  final BalanceEntity? accountBalance;
  const CashWithdrawalScreen({
    super.key,
    this.accountBalance,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<WithdrawalPricingBloc>()
              ..add(WithdrawalPricingGetEvent(
                  helperDataCubit: context.read<HelperDataCubit>()))),
        BlocProvider(
            create: (context) => sl<BankMeBloc>()
              ..add(BankMeGetEvent(
                  helperDataCubit: context.read<HelperDataCubit>()))),
        BlocProvider(create: (context) => sl<CashWithdrawalCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<WithdrawalPricingBloc, WithdrawalPricingState>(
            listener: (context, state) {
              if (state is WithdrawalPricingSuccessState) {
                context.read<CashWithdrawalCubit>().fillMinimumDenom(
                      state.priceEntity?.minimumNominal,
                    );
              }
            },
          ),
          BlocListener<BankMeBloc, BankMeState>(
            listener: (context, state) {
              if (state is BankMeSuccessState) {
                context.read<CashWithdrawalCubit>().fillBankMe(
                      state.bankMeEntity,
                    );
              }
            },
          ),
        ],
        child: _Content(accountBalance: accountBalance),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  final BalanceEntity? accountBalance;
  const _Content({
    Key? key,
    this.accountBalance,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final TextEditingController nominalCashTec = TextEditingController();

  @override
  void initState() {
    super.initState();

    nominalCashTec.addListener(
      () {
        context.read<CashWithdrawalCubit>().validate(
              t: AppLocalizations.of(context)!,
              nominalCash: nominalCashTec.text,
              currentBalance: widget.accountBalance?.nominalBalance ?? 0,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<CashWithdrawalCubit, CashWithdrawalState>(
              builder: (context, state) {
                return MainButton(
                  label: t.lblWithdrawalAccBalance,
                  onPressed: (state.isNominalError == false)
                      ? () {
                          context.goNamed(
                            AppRoutes.cashWithdrawalDetails,
                            extra: {
                              'isElite': isElite.toString(),
                              'accountBalanceEntity': widget.accountBalance,
                              'denom': double.tryParse(
                                  nominalCashTec.text.replaceAll('.', '')),
                              'fee': state.fee,
                              'bankMeEntity': state.bankMeEntity,
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
              AccountBalanceTopWidget(
                accountBalance: widget.accountBalance,
                isElite: isElite,
                onBackPressed: () => context.pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CashWithdrawalInfoWidget(isElite: isElite),
                        const SizedBox(height: 20),
                        Text(
                          t.lblCashWithdrawalAmount,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrDarkBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.lblMinCashWithdrawalAmount(
                            context
                                    .watch<CashWithdrawalCubit>()
                                    .state
                                    .minDenom
                                    ?.toIdr() ??
                                '-',
                            context
                                    .watch<CashWithdrawalCubit>()
                                    .state
                                    .fee
                                    ?.toIdr() ??
                                '-',
                            context
                                    .watch<CashWithdrawalCubit>()
                                    .minNominalCash
                                    .toIdr() ??
                                '-',
                          ),
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: (context
                                        .watch<CashWithdrawalCubit>()
                                        .state
                                        .isNominalError ==
                                    true)
                                ? clrRed
                                : (isElite
                                    ? clrWhite.withOpacity(0.75)
                                    : clrBackgroundBlack.withOpacity(0.75)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<CashWithdrawalCubit, CashWithdrawalState>(
                          builder: (context, state) {
                            return MainTextField(
                              controller: nominalCashTec,
                              hintText: t.lblHintCashWithdrawal,
                              isDarkMode: isElite,
                              textInputType: TextInputType.number,
                              textInputFormatter: [
                                CurrencyInputFormatter(),
                              ],
                              isError: state.isNominalError ?? false,
                              errorText: state.isNominalErrorMessages,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Divider(
                            thickness: 1,
                            color: (isElite ? clrWhite : clrNeutralGrey999)
                                .withOpacity(0.16),
                          ),
                        ),
                        _nominalCashItem(
                          t: t,
                          nominalCashTec: nominalCashTec,
                          isElite: isElite,
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

  Widget _nominalCashItem({
    required AppLocalizations t,
    required TextEditingController nominalCashTec,
    required bool isElite,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.lblSelectAmount,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrDarkBlue,
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<WithdrawalPricingBloc, WithdrawalPricingState>(
          builder: (context, priceState) {
            if (priceState is WithdrawalPricingLoadingState) {
              return MainGridView(
                allData: const [
                  '100000',
                  '200000',
                  '300000',
                  '400000',
                  '500000',
                  '1000000'
                ],
                maxColumn: (_) => 3,
                horzMargin: 12,
                vertMargin: 12,
                child: (_, __) => Shimmer.fromColors(
                  baseColor: clrGreyShimmerBase,
                  highlightColor: clrGreyShimmerHighlight,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: clrWhite,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              );
            }
            if (priceState is WithdrawalPricingSuccessState) {
              List<String> denomNominal = priceState
                  .priceEntity?.placeholderNominal
                  ?.map((e) => (e as String?).toIdr())
                  .toList() as List<String>;
              List<String>? denoms = denomNominal.take(5).toList();
              denoms.add(t.lblAll);
              return MainGridView<String>(
                allData: denoms,
                maxColumn: (ctr) => 3,
                horzMargin: 12,
                vertMargin: 12,
                child: (value, ctr) => InkWell(
                  onTap: () {
                    if (value == t.lblAll) {
                      nominalCashTec.text =
                          widget.accountBalance?.nominalBalance?.toIdr() ?? '0';
                      return;
                    }
                    nominalCashTec.text = value;
                    // context.read<CashWithdrawalCubit>().changeIsSelected(true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: clrNeutralGrey999.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          _denomIcon(value),
                          height: 48,
                          width: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          value,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: (isElite ? clrWhite : clrBackgroundBlack)
                                .withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  String _denomIcon(String? value) {
    switch (value) {
      case '50.000':
        return icCashWithdrawal50;
      case '100.000':
        return icCashWithdrawal100;
      case '200.000':
        return icCashWithdrawal200;
      case '300.000':
        return icCashWithdrawal300;
      case '500.000':
        return icCashWithdrawal500;
      default:
        return icCashWithdrawalall;
    }
  }
}
