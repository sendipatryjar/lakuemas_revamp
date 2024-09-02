import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../../cores/input_formater/currency_input_formater.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_grid_view.dart';
import '../blocs/pricing/pricing_bloc.dart';
import '../cubits/buy_gold/buy_gold_cubit.dart';

class BuyGoldTab extends StatefulWidget {
  final bool isElite;
  const BuyGoldTab({super.key, this.isElite = false});

  @override
  State<BuyGoldTab> createState() => _BuyGoldTabState();
}

class _BuyGoldTabState extends State<BuyGoldTab> {
  final denomTec = TextEditingController();

  @override
  void initState() {
    super.initState();
    denomTec.addListener(() {
      appPrint('denomTec: ${denomTec.text}');
      context.read<BuyGoldCubit>().validateDenom(denomTec.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: BlocBuilder<BuyGoldCubit, BuyGoldState>(
                buildWhen: (previous, current) =>
                    previous.enBuyGoldOn != current.enBuyGoldOn,
                builder: (context, state) {
                  return _tab(
                    title: 'Nominal',
                    isSelected: state.enBuyGoldOn == EnBuyGoldOn.nominal,
                    onTap: () {
                      denomTec.clear();
                      context
                          .read<BuyGoldCubit>()
                          .changeTab(EnBuyGoldOn.nominal);
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
                child: BlocBuilder<BuyGoldCubit, BuyGoldState>(
              buildWhen: (previous, current) =>
                  previous.enBuyGoldOn != current.enBuyGoldOn,
              builder: (context, state) {
                return _tab(
                  title: 'Gram',
                  isSelected: state.enBuyGoldOn == EnBuyGoldOn.gram,
                  onTap: () {
                    denomTec.clear();
                    context.read<BuyGoldCubit>().changeTab(EnBuyGoldOn.gram);
                  },
                );
              },
            )),
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<BuyGoldCubit, BuyGoldState>(
          buildWhen: (previous, current) =>
              previous.enBuyGoldOn != current.enBuyGoldOn,
          builder: (context, state) {
            String title = t.lblPurchaseAmount;
            if (state.enBuyGoldOn == EnBuyGoldOn.gram) {
              title = t.lblDesiredGramation;
            }
            return Text(
              title,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: widget.isElite ? clrWhite : clrDarkBlue,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        BlocBuilder<BuyGoldCubit, BuyGoldState>(
          buildWhen: (previous, current) =>
              (previous.enBuyGoldOn != current.enBuyGoldOn) ||
              (previous.isError != current.isError) ||
              (previous.priceEntity?.minimumNominal !=
                  current.priceEntity?.minimumNominal) ||
              (previous.priceEntity?.minimumGrammation !=
                  current.priceEntity?.minimumGrammation),
          builder: (context, state) {
            return RichText(
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              text: TextSpan(
                text: t.lblMinimum,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: state.isError
                      ? clrRed
                      : (widget.isElite ? clrWhite : clrBackgroundBlack)
                          .withOpacity(0.75),
                ),
                children: [
                  TextSpan(
                      text: state.enBuyGoldOn == EnBuyGoldOn.nominal
                          ? ' Rp ${state.priceEntity?.minimumNominal?.toIdr() ?? '-'}'
                          : ' ${state.priceEntity?.minimumGrammation ?? '-'} gram')
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        BlocBuilder<BuyGoldCubit, BuyGoldState>(
          buildWhen: (previous, current) =>
              (previous.isError != current.isError),
          builder: (context, state) {
            return Container(
              height: 64,
              width: double.infinity,
              decoration: BoxDecoration(
                color: state.isError
                    ? clrRed.withOpacity(0.25)
                    : clrGreyE5e.withOpacity(0.25),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    width: 2,
                    color: state.isError
                        ? clrRed.withOpacity(0.10)
                        : clrNeutralGrey999.withOpacity(0.16)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: BlocBuilder<BuyGoldCubit, BuyGoldState>(
                        // buildWhen: (previous, current) =>
                        //     (previous.enBuyGoldOn != current.enBuyGoldOn),
                        builder: (context, state) {
                          return TextField(
                            controller: denomTec,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: widget.isElite
                                  ? clrWhite
                                  : clrBackgroundBlack,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: state.enBuyGoldOn == EnBuyGoldOn.nominal
                                  ? t.lblFillAmount
                                  : t.lblFillGram,
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: (widget.isElite
                                        ? clrWhite
                                        : clrBackgroundBlack)
                                    .withOpacity(0.5),
                              ),
                              labelText:
                                  state.enBuyGoldOn == EnBuyGoldOn.nominal
                                      ? t.lblAmountNominal
                                      : t.lblAmountGram,
                              labelStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: (widget.isElite
                                        ? clrWhite
                                        : clrBackgroundBlack)
                                    .withOpacity(0.5),
                              ),
                            ),
                            inputFormatters:
                                state.enBuyGoldOn == EnBuyGoldOn.nominal
                                    ? [
                                        CurrencyInputFormatter(),
                                      ]
                                    : [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d*\.?\d{0,4}')),
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'^\.+'),
                                        ),
                                      ],
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        // vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: (state.isError ? clrRed : clrNeutralGrey999)
                            .withOpacity(0.16),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(15)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.lblEqualsTo,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: (widget.isElite
                                      ? clrWhite
                                      : clrBackgroundBlack)
                                  .withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 2),
                          BlocBuilder<BuyGoldCubit, BuyGoldState>(
                            buildWhen: (previous, current) =>
                                (previous.enBuyGoldOn != current.enBuyGoldOn) ||
                                (previous.equalsTo != current.equalsTo),
                            builder: (context, state) {
                              return RichText(
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                text: TextSpan(
                                  text: state.enBuyGoldOn == EnBuyGoldOn.nominal
                                      ? '${state.equalsTo ?? '0.0000'}'
                                      : 'Rp',
                                  style: TextStyle(
                                    fontSize:
                                        state.enBuyGoldOn == EnBuyGoldOn.nominal
                                            ? 16
                                            : 10,
                                    fontWeight: FontWeight.w500,
                                    color: widget.isElite
                                        ? clrWhite
                                        : clrBackgroundBlack,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: state.enBuyGoldOn ==
                                                EnBuyGoldOn.nominal
                                            ? ' gram'
                                            : ' ${state.equalsTo?.toIdr()}',
                                        style: TextStyle(
                                          fontSize: state.enBuyGoldOn ==
                                                  EnBuyGoldOn.nominal
                                              ? 10
                                              : 16,
                                        )),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Divider(
          height: 33,
          color: clrNeutralGrey999.withOpacity(0.16),
          thickness: 1,
        ),
        BlocBuilder<PricingBloc, PricingState>(
          builder: (context, priceState) {
            if (priceState is PricingLoadingState) {
              return MainGridView(
                allData: const [
                  '100000',
                  '200000',
                  '300000',
                  '400000',
                  '500000'
                ],
                maxColumn: (_) => 3,
                horzMargin: 12,
                vertMargin: 12,
                child: (_, __) => Shimmer.fromColors(
                  baseColor: clrGreyShimmerBase,
                  highlightColor: clrGreyShimmerHighlight,
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: clrWhite,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              );
            }
            if (priceState is PricingSuccessState) {
              return BlocBuilder<BuyGoldCubit, BuyGoldState>(
                builder: (context, state) {
                  List<String> denomNominal = priceState
                      .priceEntity?.placeholderNominal
                      ?.map((e) => (e as String?).toIdr())
                      .toList() as List<String>;
                  List<dynamic>? denoms =
                      state.enBuyGoldOn == EnBuyGoldOn.nominal
                          ? denomNominal
                          : priceState.priceEntity?.placeholderGrammation;
                  return MainGridView<dynamic>(
                    allData: denoms ?? [],
                    maxColumn: (ctr) => 3,
                    horzMargin: 12,
                    vertMargin: 12,
                    child: (value, ctr) => InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      onTap: () {
                        denomTec.text = value;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: clrNeutralGrey999.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          value,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color:
                                (widget.isElite ? clrWhite : clrBackgroundBlack)
                                    .withOpacity(0.75),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _tab(
      {required String title, bool isSelected = false, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? clrYellow : clrNeutralGrey999.withOpacity(0.16),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? clrBackgroundBlack
                : (widget.isElite ? clrWhite : clrBackgroundBlack)
                    .withOpacity(0.75),
          ),
        ),
      ),
    );
  }
}
