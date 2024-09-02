import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/extensions/currency_extension.dart';
import '../../_core/transaction/domain/entities/price_entity.dart';
import '../../coupon/domain/entities/coupon_detail_entity.dart';
import 'blocs/balance/bgold_balance_bloc.dart';
import 'blocs/checkout/checkout_bloc.dart';
import 'blocs/pricing/pricing_bloc.dart';
import 'cubits/buy_gold/buy_gold_cubit.dart';
import 'widgets/buy_gold_balance_widget.dart';
import 'widgets/buy_gold_tab.dart';

class BuyGoldScreen extends StatelessWidget {
  final CouponDetailEntity? couponDetailEntity;
  final bool isFromElite;
  final bool isFromGrafik;
  final PriceEntity? priceEntity;
  final String? backScreen;
  final Map<String, dynamic>? extra;
  const BuyGoldScreen({
    super.key,
    this.couponDetailEntity,
    this.isFromElite = false,
    this.isFromGrafik = false,
    this.priceEntity,
    this.backScreen,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<BuyGoldCubit>()..changeCoupon(value: couponDetailEntity),
        ),
        BlocProvider(
          create: (context) => sl<BgoldBalanceBloc>()
            ..add(BgoldGetBalanceEvent(
              helperDataCubit: context.read<HelperDataCubit>(),
            )),
        ),
        BlocProvider(
          create: (context) => sl<PricingBloc>()
            ..add(PricingGetEvent(
              helperDataCubit: context.read<HelperDataCubit>(),
            )),
        ),
        BlocProvider(
          create: (context) => sl<CheckoutBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<BgoldBalanceBloc, BgoldBalanceState>(
            listener: (context, state) {
              if (state is BgoldBalanceSuccessState) {
                context.read<BuyGoldCubit>().changeBalance(state.balanceEntity);
              }
            },
          ),
          BlocListener<PricingBloc, PricingState>(
            listener: (context, state) {
              if (state is PricingSuccessState) {
                context.read<BuyGoldCubit>().changePricing(state.priceEntity);
              }
            },
          ),
        ],
        child: _Content(
          backScreen: backScreen,
          extra: extra,
          isFromElite: isFromElite,
          isFromGrafik: isFromGrafik,
          priceEntity: priceEntity,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final bool isFromElite;
  final bool isFromGrafik;
  final PriceEntity? priceEntity;
  final String? backScreen;
  final Map<String, dynamic>? extra;
  const _Content({
    Key? key,
    this.isFromElite = false,
    this.isFromGrafik = false,
    this.priceEntity,
    this.backScreen,
    this.extra,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // var maxHeight = MediaQuery.of(context).size.height;
    double bottomSheetHeight = 112;
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocListener<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is CheckoutLoadingState) {
              EasyLoading.show();
            }
            if (state is CheckoutSuccessState) {
              EasyLoading.dismiss();

              context.goNamed(
                AppRoutes.paymentMethod,
                extra: {
                  'isElite': isElite.toString(),
                  'backScreen': AppRoutes.buyGold,
                  'checkout': state.checkoutEntity,
                  'couponDetailEntity':
                      context.read<BuyGoldCubit>().state.couponDetailEntity,
                },
              );
            }
            if (state is CheckoutFailureState) {
              EasyLoading.dismiss();
              if (state.appFailure is ServerFailure) {
                context.goNamed(
                  AppRoutes.serverError,
                  extra: {
                    "isBack": "true",
                    "parentScreenName": AppRoutes.buyGold,
                    "couponDetailEntity":
                        context.read<BuyGoldCubit>().state.couponDetailEntity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuyGoldBalanceWidget(
                      isElite: isElite,
                      backScreen: backScreen,
                      extra: extra,
                      isFromElite: isFromElite,
                      isFromGrafik: isFromGrafik,
                      priceEntity: priceEntity,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 26),
                            SizedBox(
                              width: double.infinity,
                              child: BlocBuilder<BuyGoldCubit, BuyGoldState>(
                                buildWhen: (previous, current) =>
                                    previous.priceEntity?.price !=
                                    current.priceEntity?.price,
                                builder: (context, state) {
                                  var currGoldPrice =
                                      state.priceEntity?.price != null
                                          ? state.priceEntity?.price?.toIdr()
                                          : '-';
                                  return RichText(
                                      textScaler: TextScaler.linear(
                                          TextUtils.textScaleFactor(context)),
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: '${t.lblCurrBuyPrice}: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: isElite
                                                ? clrWhite
                                                : clrBackgroundBlack,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'IDR $currGoldPrice/gram',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ]));
                                },
                              ),
                            ),
                            const SizedBox(height: 26),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: BuyGoldTab(isElite: isElite),
                            ),
                            _couponField(isElite: isElite),
                            const SizedBox(height: 128),
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
                      double maxChildSize = 192 / constraints.maxHeight;
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
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 20),
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${t.lblBuy} ${t.lblGold}',
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
                                            BlocBuilder<BuyGoldCubit,
                                                BuyGoldState>(
                                              builder: (context, state) {
                                                return RichText(
                                                  textScaler: TextScaler.linear(
                                                      TextUtils.textScaleFactor(
                                                          context)),
                                                  text: TextSpan(
                                                    text: 'Rp',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: isElite
                                                          ? clrWhite
                                                          : clrBackgroundBlack,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            ' ${state.totalPrice?.toIdr() ?? '0'}',
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                            Text(
                                              'Pembulatan masuk Saldo Akun',
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
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      BlocBuilder<BuyGoldCubit, BuyGoldState>(
                                        buildWhen: (previous, current) =>
                                            (previous.isError !=
                                                current.isError) ||
                                            (previous.denom != current.denom),
                                        builder: (context, state) {
                                          return MainButton(
                                            label: t.lblNext,
                                            labelTextAlign: TextAlign.center,
                                            labelStyle: isElite
                                                ? TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: clrBackgroundBlack,
                                                  )
                                                : null,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 16),
                                            onPressed: (state.isError ==
                                                        false &&
                                                    (state.denom ?? 0) > 0)
                                                ? () {
                                                    context
                                                        .read<CheckoutBloc>()
                                                        .add(CheckoutNowEvent(
                                                            state.denom,
                                                            state.enBuyGoldOn ==
                                                                    EnBuyGoldOn
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
                                  BlocBuilder<BuyGoldCubit, BuyGoldState>(
                                    builder: (context, state) {
                                      return _amountWidget(
                                        context,
                                        title:
                                            '${state.enBuyGoldOn == EnBuyGoldOn.nominal ? (state.equalsTo ?? '0') : (state.denom ?? '0')} gr x Rp ${state.priceEntity?.price?.toIdr() ?? '-'}',
                                        amount: state.truePrice?.toIdr() ?? '-',
                                        isElite: isElite,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  BlocBuilder<BuyGoldCubit, BuyGoldState>(
                                    builder: (context, state) {
                                      return _amountWidget(
                                        context,
                                        title:
                                            'Pembulatan (Masuk ke Saldo Akun)',
                                        amount: (state.rounding ?? 0).toIdr(),
                                        isElite: isElite,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  BlocBuilder<BuyGoldCubit, BuyGoldState>(
                                    builder: (context, state) {
                                      String? title = "Pajak";
                                      String? taxNominalStr =
                                          state.priceEntity?.taxNominal;
                                      String? taxPercentageStr =
                                          state.priceEntity?.taxPercentage;
                                      if (((taxNominalStr ?? "").isEmpty ||
                                              (taxNominalStr ?? "") == "0") &&
                                          taxPercentageStr != null) {
                                        title += " ($taxPercentageStr%)";
                                      }
                                      double tax = double.tryParse(
                                              taxNominalStr ?? "") ??
                                          ((state.price ?? 0) *
                                              (double.tryParse(
                                                      taxPercentageStr ?? '') ??
                                                  0) /
                                              100);

                                      if (tax <= 0) {
                                        return const SizedBox();
                                      }

                                      return _amountWidget(
                                        context,
                                        title: title,
                                        amount: tax.toIdr() ?? "-",
                                        isElite: isElite,
                                      );
                                    },
                                  ),
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

  BlocBuilder<BuyGoldCubit, BuyGoldState> _couponField({bool isElite = false}) {
    return BlocBuilder<BuyGoldCubit, BuyGoldState>(
      buildWhen: (previous, current) =>
          previous.couponDetailEntity != current.couponDetailEntity,
      builder: (context, state) {
        var couponDetailEntity = state.couponDetailEntity;
        if (couponDetailEntity != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 49),
                Text(
                  'Kupon Yang Digunakan',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    color: isElite ? clrWhite : clrDarkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: clrGreyE5e.withOpacity(0.05),
                    border: Border.all(
                        width: 2, color: clrNeutralGrey999.withOpacity(0.16)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            couponDetailEntity.couponCode ?? '-',
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              color:
                                  isElite ? clrWhite : const Color(0xFF1E1E1E),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              appPrint('delete coupon pressed');
                              context
                                  .read<BuyGoldCubit>()
                                  .changeCoupon(isNullify: true, value: null);
                            },
                            child: Text(
                              'Hapus Kupon',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFFFF4242),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(height: 17),
                      Text(
                        'Minimal pembelian Rp. ${couponDetailEntity.minimumAmount.toIdr()}',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          color: isElite
                              ? clrWhite.withOpacity(0.75)
                              : const Color(0x7F1E1E1E),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
