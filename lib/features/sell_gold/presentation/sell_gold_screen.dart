import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_banner.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/transaction/domain/entities/price_entity.dart';
import 'blocs/balance/sgold_balance_bloc.dart';
import 'blocs/pricing/sgold_pricing_bloc.dart';
import 'blocs/sell_gold_checkout/sell_gold_checkout_bloc.dart';
import 'cubits/buy_gold/sell_gold_cubit.dart';
import 'widgets/sell_gold_balance_widget.dart';
import 'widgets/sell_gold_tab.dart';

class SellGoldScreen extends StatelessWidget {
  final bool isFromGrafik;
  final PriceEntity? priceEntity;
  const SellGoldScreen({
    this.isFromGrafik = false,
    this.priceEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SellGoldCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SgoldBalanceBloc>()
            ..add(SgoldGetBalanceEvent(
              helperDataCubit: context.read<HelperDataCubit>(),
            )),
        ),
        BlocProvider(
          create: (context) => sl<SgoldPricingBloc>()
            ..add(SgoldPricingGetEvent(
              helperDataCubit: context.read<HelperDataCubit>(),
            )),
        ),
        BlocProvider(
          create: (context) => sl<SellGoldCheckoutBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SgoldPricingBloc, SgoldPricingState>(
            listener: (context, state) {
              if (state is SgoldPricingSuccessState) {
                context.read<SellGoldCubit>().changePricing(state.priceEntity);
              }
            },
          ),
        ],
        child: _Content(
          isFromGrafik: isFromGrafik,
          priceEntity: priceEntity,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final bool isFromGrafik;
  final PriceEntity? priceEntity;
  const _Content({
    this.isFromGrafik = false,
    this.priceEntity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // var maxHeight = MediaQuery.of(context).size.height;
    double bottomSheetHeight = 96;
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocListener<SellGoldCheckoutBloc, SellGoldCheckoutState>(
          listener: (context, state) {
            if (state is SellGoldCheckoutLoadingState) {
              EasyLoading.show();
            }
            if (state is SellGoldCheckoutSuccessState) {
              EasyLoading.dismiss();

              context.goNamed(
                AppRoutes.sellGoldConfirmation,
                extra: {
                  'isElite': isElite.toString(),
                  'eliteCubit': context.read<EliteCubit>(),
                  'checkout': state.checkoutEntity,
                },
              );
            }
            if (state is SellGoldCheckoutFailureState) {
              EasyLoading.dismiss();
              if (state.appFailure is ServerFailure) {
                context.goNamed(
                  AppRoutes.serverError,
                  extra: {
                    "isElite": context.read<EliteCubit>().state.toString(),
                    "eliteCubit": context.read<EliteCubit>(),
                    "parentScreenName": AppRoutes.sellGold,
                  },
                );
                return;
              }
              EasyLoading.showError(
                errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                dismissOnTap: true,
              );
            }
          },
          child: Scaffold(
            backgroundColor: isElite ? clrBlack101 : null,
            body: Stack(
              children: [
                Column(
                  children: [
                    SellGoldBalanceWidget(
                      isElite: isElite,
                      isFromGrafik: isFromGrafik,
                      priceEntity: priceEntity,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 26),
                            BlocBuilder<SellGoldCubit, SellGoldState>(
                              buildWhen: (previous, current) =>
                                  previous.priceEntity?.price !=
                                  current.priceEntity?.price,
                              builder: (context, state) {
                                return RichText(
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    text: TextSpan(
                                        text: '${t.lblCurrSellingPrice}: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: isElite
                                              ? clrWhite
                                              : clrBackgroundBlack,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                'IDR ${state.priceEntity?.price?.toIdr() ?? '-'}/gram',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ]));
                              },
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: MainBanner(
                                bgColor: clrYellow.withOpacity(0.16),
                                content: Row(
                                  children: [
                                    Image.asset(
                                      icWarningOrange,
                                      height: 16,
                                      width: 16,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        t.lblSellGoldTimeWarning,
                                        textScaler: TextScaler.linear(
                                            TextUtils.textScaleFactor(context)),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: isElite
                                              ? clrWhite
                                              : clrBackgroundBlack,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SellGoldTab(isElite: isElite),
                            ),
                            SizedBox(height: bottomSheetHeight + 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double initialChildSize =
                          bottomSheetHeight / constraints.maxHeight;
                      double minChildSize =
                          bottomSheetHeight / constraints.maxHeight;
                      double maxChildSize = 157 / constraints.maxHeight;
                      return DraggableScrollableSheet(
                        initialChildSize: initialChildSize,
                        minChildSize: minChildSize,
                        maxChildSize: maxChildSize,
                        builder: (context, scrollController) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              constraints:
                                  BoxConstraints(minHeight: maxChildSize),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isElite ? clrBlack080 : clrWhite,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${t.lblSell} ${t.lblGold}',
                                            textScaler: TextScaler.linear(
                                                TextUtils.textScaleFactor(
                                                    context)),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: (isElite
                                                      ? clrWhite
                                                      : clrBackgroundBlack)
                                                  .withOpacity(0.75),
                                            ),
                                          ),
                                          BlocBuilder<SellGoldCubit,
                                              SellGoldState>(
                                            builder: (context, state) {
                                              return RichText(
                                                textScaler: TextScaler.linear(
                                                    TextUtils.textScaleFactor(
                                                        context)),
                                                text: TextSpan(
                                                  text: 'Rp',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: isElite
                                                        ? clrWhite
                                                        : clrBackgroundBlack,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          ' ${state.totalPrice?.toIdr() ?? '0'}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: (state.isError &&
                                                                (state.totalPrice ??
                                                                        0) >
                                                                    0)
                                                            ? clrRed
                                                                .withOpacity(
                                                                    0.7)
                                                            : null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      BlocBuilder<SellGoldCubit, SellGoldState>(
                                        buildWhen: (previous, current) =>
                                            (previous.isError !=
                                                current.isError) ||
                                            (previous.denom != current.denom),
                                        builder: (context, state) {
                                          return MainButton(
                                            label: t.lblNext,
                                            labelStyle: isElite
                                                ? TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: clrBackgroundBlack,
                                                  )
                                                : null,
                                            onPressed:
                                                (state.isError == false &&
                                                        (state.denom ?? 0) > 0)
                                                    ? () {
                                                        context
                                                            .read<
                                                                SellGoldCheckoutBloc>()
                                                            .add(SellGoldCheckoutNowEvent(
                                                                state.denom,
                                                                state.enSellGoldOn ==
                                                                        EnSellGoldOn
                                                                            .nominal
                                                                    ? 'nominal'
                                                                    : 'grammation'));
                                                      }
                                                    : null,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 41),
                                  BlocBuilder<SellGoldCubit, SellGoldState>(
                                    builder: (context, state) {
                                      return _amountWidget(
                                        context,
                                        title:
                                            '${state.enSellGoldOn == EnSellGoldOn.nominal ? (state.equalsTo ?? '0') : (state.denom ?? '0')} gr x Rp ${state.priceEntity?.price?.toIdr() ?? '-'}',
                                        amount: state.price?.toIdr() ?? '-',
                                        isElite: isElite,
                                      );
                                    },
                                  ),
                                  // const SizedBox(height: 10),
                                  // BlocBuilder<SellGoldCubit, SellGoldState>(
                                  //   builder: (context, state) {
                                  //     return _amountWidget(
                                  //       title:
                                  //           '${t.lblTaxRateClause22}, ${(state.priceEntity?.taxPercentage ?? 0)}%',
                                  //       amount:
                                  //           'Rp ${context.watch<SellGoldCubit>().taxNominal.toIdr()}',
                                  //       isElite: isElite,
                                  //     );
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _amountWidget(
    BuildContext context, {
    String? title,
    Widget? titleWidget,
    String? amount,
    bool isElite = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: title != null
                ? Text(
                    title,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: (isElite ? clrWhite : clrBackgroundBlack)
                          .withOpacity(0.75),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: (titleWidget ?? const SizedBox()),
                  ),
          ),
          RichText(
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            text: TextSpan(
                text: 'Rp',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: (isElite ? clrWhite : clrBackgroundBlack)
                      .withOpacity(0.75),
                ),
                children: [
                  TextSpan(
                    text: ' ${(amount ?? '')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
