import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../blocs/gold_details_balances/gold_details_balances_bloc.dart';
import '../blocs/gold_income/gold_income_bloc.dart';

class GoldDetailsTab extends StatelessWidget {
  final bool isElite;
  const GoldDetailsTab({super.key, required this.isElite});

  void mainCopyData({
    required BuildContext context,
    required String text,
    String? snackbarText,
  }) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarText ?? "berhasil disalin"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(height: 32),
        _yourIncome(context, t, isElite),
      ],
    );
  }

  Widget _yourIncome(BuildContext context, AppLocalizations t, bool isElite) =>
      Container(
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: isElite
              ? clrGreyE5e.withOpacity(0.12)
              : clrGreyE5e.withOpacity(0.25),
          border: Border.all(color: clrNeutralGrey999.withOpacity(0.16)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${t.lblAccountNumber} Lakuemas',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  BlocBuilder<GoldDetailsBalancesBloc,
                      GoldDetailsBalancesState>(
                    builder: (context, state) {
                      String norek = '-';
                      if (state is GoldDetailsBalanceSuccessState) {
                        norek = state.goldBalanceEntity?.accountNumber ?? '-';
                      }
                      return GestureDetector(
                        onTap: () {
                          mainCopyData(
                            context: context,
                            text: norek,
                            snackbarText: 'Nomor rekening berhasil disalin',
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              norek,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.copy,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                              size: 14,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
                height: 33,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.lblAvgGoldPrice,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  BlocBuilder<GoldIncomeBloc, GoldIncomeState>(
                    builder: (context, state) {
                      String avgPurchasePrice = '-';
                      if (state is GoldIncomeSuccessState) {
                        avgPurchasePrice =
                            state.goldIncomeEntity.avgPurchasePrice.toIdr();
                      }
                      return Text(
                        'Rp $avgPurchasePrice/gram',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
                height: 33,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.lblGoldValue,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  BlocBuilder<GoldIncomeBloc, GoldIncomeState>(
                    builder: (context, state) {
                      String goldValue = '-';
                      if (state is GoldIncomeSuccessState) {
                        goldValue = state.goldIncomeEntity.goldValue.toIdr();
                      }
                      return Text(
                        ' Rp ${goldValue.isEmpty ? '0' : goldValue}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
                height: 33,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.lblCurrentSellPrice,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  BlocBuilder<GoldIncomeBloc, GoldIncomeState>(
                    builder: (context, state) {
                      String purchasePrice = '-';
                      if (state is GoldIncomeSuccessState) {
                        purchasePrice =
                            state.goldIncomeEntity.purchasePrice.toIdr();
                      }
                      return Text(
                        'Rp ${purchasePrice.isEmpty ? '0' : purchasePrice}/gram',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
                height: 33,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.lblMarkerSellValue,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  BlocBuilder<GoldIncomeBloc, GoldIncomeState>(
                    builder: (context, state) {
                      String marketPrice = '-';
                      if (state is GoldIncomeSuccessState) {
                        marketPrice =
                            state.goldIncomeEntity.marketPrice.toIdr();
                      }
                      return Text(
                        'Rp ${marketPrice.isEmpty ? '0' : marketPrice}',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: const BoxDecoration(
                // color: clrYellow.withOpacity(0.5),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${t.lblIncome} (Rp)',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  BlocBuilder<GoldIncomeBloc, GoldIncomeState>(
                    builder: (context, state) {
                      String incomeValue = '-';
                      if (state is GoldIncomeSuccessState) {
                        incomeValue =
                            state.goldIncomeEntity.incomeValue.toIdr();
                      }
                      return RichText(
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        text: TextSpan(
                          text: 'Rp ${incomeValue.isEmpty ? '0' : incomeValue}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: incomeValue.startsWith('-')
                                ? clrRed
                                : clrGreen00B,
                            // isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              decoration: const BoxDecoration(
                // color: clrYellow.withOpacity(0.5),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${t.lblIncome} (%)',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  BlocBuilder<GoldIncomeBloc, GoldIncomeState>(
                    builder: (context, state) {
                      String incomePercentage = '-';
                      if (state is GoldIncomeSuccessState) {
                        incomePercentage = state
                            .goldIncomeEntity.incomePercentage!
                            .substring(0, 6);
                      }
                      return RichText(
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        text: TextSpan(
                          text:
                              '  ${incomePercentage.isEmpty ? '0' : incomePercentage}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: incomePercentage.startsWith('-')
                                ? clrRed
                                : clrGreen00B,
                            // isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
}
