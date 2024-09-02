import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/utils/validation_utils.dart';
import '../../../cores/widgets/card_list_widget.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../_core/transaction/domain/entities/checkout_entity.dart';
import '../domain/entities/payment_method_entity.dart';
import 'blocs/payment/payment_bloc.dart';
import 'cubits/payment/payment_cubit.dart';
import 'widgets/debet_detail_card_widget.dart';
import 'widgets/method_widget.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final bool isValidated;
  const PaymentConfirmationScreen({super.key, this.isValidated = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final paymentCbtState = context.read<PaymentCubit>().state;
    if (isValidated) {
      appPrint('isValidated: $isValidated');
    }
    return BlocProvider(
      create: (context) {
        if (isValidated) {
          return sl<PaymentBloc>()
            ..add(PaymentDoNowEvent(
              paymentMethodId: paymentCbtState.paymentMethodEntity!.id!,
              transactionKey: paymentCbtState.checkoutEntity!.transactionKey!,
              phoneNumber: paymentCbtState.ovoPhoneNumber,
              couponCode: paymentCbtState.couponDetailEntity?.couponCode,
              paymentDebetEntity: paymentCbtState.paymentDebetEntity,
            ));
        }
        return sl<PaymentBloc>();
      },
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentLoadingState) {
            EasyLoading.show();
            appPrint('payment loading...');
          }
          if (state is PaymentSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.paymentWaiting,
              extra: {
                'eliteCubit': context.read<EliteCubit>(),
                'transactionCode': state.payment?.transactionCode,
              },
            );
          }
          if (state is PaymentFailureState) {
            EasyLoading.dismiss();
            if (state.appFailure is ServerFailure) {
              context.goNamed(
                AppRoutes.paymentServerError,
                extra: {
                  "isElite": context.read<EliteCubit>().state.toString(),
                  "checkout": context.read<PaymentCubit>().state.checkoutEntity,
                  "couponDetailEntity":
                      context.read<PaymentCubit>().state.couponDetailEntity,
                  "paymentCubit": context.read<PaymentCubit>(),
                  "eliteCubit": context.read<EliteCubit>(),
                  "parentScreenName": AppRoutes.paymentConfirmation,
                },
              );
              return;
            }
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
            context.goNamed(
              AppRoutes.paymentConfirmation,
              extra: {
                'eliteCubit': context.read<EliteCubit>(),
                'paymentCubit': context.read<PaymentCubit>(),
                'checkout': context.read<PaymentCubit>().state.checkoutEntity,
                'isValidated': false,
              },
            );
          }
        },
        child: _Content(t: t, isValidated: isValidated),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  final bool isValidated;
  _Content({
    Key? key,
    required this.t,
    this.isValidated = false,
  }) : super(key: key);

  final formKey = GlobalKey<FormState>();

  _backPressed(BuildContext context, bool isElite) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              '${t.lblSelect} ${t.lblPaymentMethods}',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                _backPressed(context, isElite);
              },
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: t.lblCompletePayment,
              onPressed: isValidated
                  ? null
                  : () {
                      final paymentCbt = context.read<PaymentCubit>();
                      final paymentCbtState =
                          context.read<PaymentCubit>().state;
                      if (paymentCbtState.paymentMethodSelected == 25) {
                        context.read<PaymentCubit>().updateDebetCardNumber(
                              t: t,
                              cardNumber: paymentCbtState
                                  .paymentDebetEntity?.cardNumber,
                            );
                        context.read<PaymentCubit>().updateDebetExpDate(
                              t: t,
                              expDate:
                                  '${paymentCbtState.paymentDebetEntity?.month}/${paymentCbtState.paymentDebetEntity?.year}',
                            );
                        context.read<PaymentCubit>().updateDebetCvv(
                              t: t,
                              cvv: paymentCbtState.paymentDebetEntity?.cvv,
                            );
                      } else {
                        context.read<PaymentCubit>().resetDebet();
                      }
                      var isValidated = formKey.currentState?.validate();
                      appPrint(
                        'isValidated: $isValidated, couponErrMessage: ${paymentCbtState.couponErrMessage}',
                      );
                      if (paymentCbtState.couponErrMessage != null ||
                          isValidated == false ||
                          paymentCbt.isDebetValid() == false) return;
                      appPrint('do action');
                      context.goNamed(
                        AppRoutes.pin,
                        extra: {
                          'pinType': '${PinType.validate}',
                          'backScreenPin': AppRoutes.paymentConfirmation,
                          'nextScreenPin': AppRoutes.paymentConfirmation,
                          'eliteCubit': context.read<EliteCubit>(),
                          'paymentCubit': context.read<PaymentCubit>(),
                          'checkout':
                              context.read<PaymentCubit>().state.checkoutEntity
                        },
                      );
                    },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.lblCouponCode,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<PaymentCubit, PaymentCbtState>(
                    buildWhen: (previous, current) =>
                        (previous.couponDetailEntity !=
                            current.couponDetailEntity) ||
                        (previous.couponErrMessage != current.couponErrMessage),
                    builder: (context, state) {
                      bool isCouponExist =
                          state.couponDetailEntity?.couponCode != null;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CardListWidget(
                            isUseDevider: false,
                            isUseRightArrow: isCouponExist ? false : true,
                            isElite: isElite,
                            itemLength: 1,
                            title: (_) => state.couponDetailEntity != null
                                ? (state.couponDetailEntity?.couponCode ??
                                    'no coupon code')
                                : t.lblEnterCouponCode,
                            titleStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: state.couponErrMessage != null
                                  ? clrRed
                                  : isElite
                                      ? clrWhite
                                      : clrBackgroundBlack,
                            ),
                            borderColor:
                                state.couponErrMessage != null ? clrRed : null,
                            rightWidget: isCouponExist
                                ? (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        context
                                            .read<PaymentCubit>()
                                            .removeCoupon();
                                      },
                                      child: Text(
                                        t.lblRemove,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: clrRed,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            onTap: isCouponExist
                                ? null
                                : (index) {
                                    var payCubit = context.read<PaymentCubit>();
                                    context.goNamed(
                                      AppRoutes.couponRedeem,
                                      extra: {
                                        'isElite':
                                            '${context.read<EliteCubit>().state}',
                                        'eliteCubit':
                                            context.read<EliteCubit>(),
                                        'paymentCubit': payCubit,
                                        'checkout': context
                                            .read<PaymentCubit>()
                                            .state
                                            .checkoutEntity,
                                        'backScreen':
                                            AppRoutes.paymentConfirmation,
                                      },
                                    );
                                  },
                          ),
                          if (state.couponErrMessage != null)
                            Container(
                              padding: const EdgeInsets.only(
                                top: 4,
                                right: 4,
                                left: 4,
                              ),
                              width: double.infinity,
                              child: Text(
                                state.couponErrMessage ?? '',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: clrRed,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t.lblPaymentMethods,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _paymentMethodWidget(t, formKey, isElite),
                  const SizedBox(height: 40),
                  Text(
                    t.lblOrderDetails,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: isElite
                          ? clrGreyE5e.withOpacity(0.12)
                          : clrGreyE5e.withOpacity(0.25),
                      border: Border.all(
                          color: (isElite ? clrWhite : clrNeutralGrey999)
                              .withOpacity(0.16)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: BlocBuilder<PaymentCubit, PaymentCbtState>(
                      builder: (context, paymentCbtState) {
                        double pgServiceFee = _serviceFeeOnDetailsOrder(
                          paymentCbtState.paymentMethodEntity,
                          paymentCbtState.checkoutEntity,
                        ).ceilToDouble();
                        // double price = ((double.tryParse(paymentCbtState
                        //                     .checkoutEntity?.goldAmount ??
                        //                 '') ??
                        //             0) *
                        //         (double.tryParse(paymentCbtState
                        //                     .checkoutEntity?.goldPrice ??
                        //                 '') ??
                        //             0))
                        //     .ceilToDouble();
                        double price = (double.tryParse(
                                paymentCbtState.checkoutEntity?.amount ?? '') ??
                            0);
                        double taxNominal = double.tryParse(
                                paymentCbtState.checkoutEntity?.nominalTax ??
                                    '') ??
                            0;
                        double rounding = (double.tryParse(
                                paymentCbtState.checkoutEntity?.rounding ??
                                    '') ??
                            0);
                        // coupon disc
                        double maxDisc = double.parse(paymentCbtState
                                .couponDetailEntity?.maximumDiscountNominal ??
                            '0');
                        double helperDisc = double.parse(paymentCbtState
                                .couponDetailEntity?.discountNominal ??
                            '0');
                        if ((paymentCbtState.couponDetailEntity
                                        ?.discountPercentage ??
                                    '')
                                .isNotEmpty &&
                            (paymentCbtState.couponDetailEntity
                                        ?.discountPercentage ??
                                    '0') !=
                                '0') {
                          helperDisc = (double.parse(paymentCbtState
                                          .couponDetailEntity
                                          ?.discountPercentage ??
                                      '0') /
                                  100) *
                              price;
                        }
                        double couponDiscount =
                            (helperDisc > maxDisc) ? maxDisc : helperDisc;
                        //
                        double totalPay = (pgServiceFee + price + taxNominal);
                        if (couponDiscount > 0 &&
                            paymentCbtState.couponErrMessage == null) {
                          totalPay = totalPay - couponDiscount;
                        }
                        return Column(
                          children: [
                            if (paymentCbtState.paymentMethodEntity?.id != 28)
                              _amountWidget(
                                context,
                                title: t.lblServiceFee(_title(
                                    t, paymentCbtState.paymentMethodEntity)),
                                amount: pgServiceFee.toIdr(),
                                isElite: isElite,
                              ),
                            if (paymentCbtState.paymentMethodEntity?.id != 28)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  height: 33,
                                  color: clrNeutralGrey999.withOpacity(0.16),
                                ),
                              ),
                            _amountWidget(
                              context,
                              titleWidget: RichText(
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                text: TextSpan(
                                    text: paymentCbtState
                                            .checkoutEntity?.goldAmount ??
                                        '-',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isElite
                                          ? clrWhite
                                          : clrBackgroundBlack,
                                    ),
                                    children: [
                                      const TextSpan(
                                          text: ' gr',
                                          style: TextStyle(fontSize: 10)),
                                      const TextSpan(
                                          text: ' x',
                                          style: TextStyle(fontSize: 14)),
                                      const TextSpan(
                                          text: ' Rp',
                                          style: TextStyle(fontSize: 10)),
                                      TextSpan(
                                          text:
                                              ' ${paymentCbtState.checkoutEntity?.goldPrice?.toIdr()}'),
                                    ]),
                              ),
                              amount: (price - rounding).toIdr(),
                              isElite: isElite,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                height: 33,
                                color: clrNeutralGrey999.withOpacity(0.16),
                              ),
                            ),
                            // _amountWidget(
                            //   title:
                            //       '${t.lblTaxRateClause22}, (${paymentCbtState.checkoutEntity?.percentageTax ?? 0}%)',
                            //   amount: taxNominal.toIdr(),
                            //   isElite: isElite,
                            // ),
                            _amountWidget(
                              context,
                              title: 'Pembulatan (Masuk Saldo Akun)',
                              amount: rounding.toIdr(),
                              isElite: isElite,
                            ),
                            if (taxNominal > 0) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  height: 33,
                                  color: clrNeutralGrey999.withOpacity(0.16),
                                ),
                              ),
                              _amountWidget(
                                context,
                                title:
                                    'Pajak (${paymentCbtState.checkoutEntity?.percentageTax ?? ""}%)',
                                amount: taxNominal.toIdr(),
                                isElite: isElite,
                              ),
                            ],
                            if (couponDiscount > 0 &&
                                paymentCbtState.couponErrMessage == null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  height: 33,
                                  color: clrNeutralGrey999.withOpacity(0.16),
                                ),
                              ),
                            if (couponDiscount > 0 &&
                                paymentCbtState.couponErrMessage == null)
                              _amountWidget(
                                context,
                                title: t.lblTotalDiscount,
                                amount: couponDiscount.toIdr(),
                                isElite: isElite,
                              ),
                            const SizedBox(height: 16),
                            // if (paymentCbtState.isNpwpAlreadyKyc != true)
                            //   GestureDetector(
                            //     onTap: () {
                            //       context.goNamed(
                            //         AppRoutes.accountVerification,
                            //       );
                            //     },
                            //     child: Container(
                            //       padding: const EdgeInsets.symmetric(
                            //         horizontal: 20,
                            //         vertical: 16,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: clrYellow.withOpacity(0.16),
                            //       ),
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Expanded(
                            //             child: Text(
                            //               t.lblFillYourNpwp('0.45%'),
                            //               style: TextStyle(
                            //                 fontSize: 11,
                            //                 fontWeight: FontWeight.w500,
                            //                 color: isElite
                            //                     ? clrWhite
                            //                     : clrBackgroundBlack,
                            //               ),
                            //             ),
                            //           ),
                            //           Icon(
                            //             Icons.keyboard_arrow_right,
                            //             color: isElite ? clrWhite : null,
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: clrYellow.withOpacity(0.5),
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(30)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    t.lblTotalPayment,
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isElite
                                          ? clrWhite
                                          : clrBackgroundBlack,
                                    ),
                                  ),
                                  RichText(
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    text: TextSpan(
                                        text: 'Rp',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isElite
                                              ? clrWhite
                                              : clrBackgroundBlack,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' ${totalPay.toIdr()}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _amountWidget(BuildContext context,
      {String? title,
      Widget? titleWidget,
      String? amount,
      bool isElite = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: title != null
                ? Text(
                    title,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isElite ? clrWhite : clrBackgroundBlack,
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
                text: title == t.lblTotalDiscount ? '- Rp' : 'Rp',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isElite
                      ? (title == t.lblTotalDiscount ? clrGreen00A : clrWhite)
                      : (title == t.lblTotalDiscount
                          ? clrGreen00A
                          : clrBackgroundBlack),
                ),
                children: [
                  TextSpan(
                    text: ' ${(amount ?? '')}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodWidget(
      AppLocalizations t, GlobalKey formKey, bool isElite) {
    return BlocBuilder<PaymentCubit, PaymentCbtState>(
      builder: (context, paymentCbtState) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isElite
                ? clrGreyE5e.withOpacity(0.12)
                : clrGreyE5e.withOpacity(0.25),
            border: Border.all(
                color: isElite
                    ? clrNeutralGrey999.withOpacity(0.16)
                    : clrNeutralGrey999.withOpacity(0.16)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MethodWidget(
                contentPadding: const EdgeInsets.all(0),
                imageUrl: paymentCbtState.paymentMethodEntity?.imageUrl,
                title: _title(t, paymentCbtState.paymentMethodEntity),
                subTitle: _serviceFee(paymentCbtState.paymentMethodEntity),
                isElite: isElite,
              ),
              if (paymentCbtState.paymentMethodEntity?.id == 28)
                _accountBalanceWidget(
                  t,
                  paymentCbtState,
                  isElite,
                  context,
                ),
              if (paymentCbtState.paymentMethodEntity?.id == 24)
                _ovoWidget(
                  t,
                  paymentCbtState,
                  isElite,
                  formKey,
                  context,
                ),
              if (paymentCbtState.paymentMethodEntity?.id == 25) ...[
                Divider(
                  height: 33,
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
                const DebetDetailCardWidget(),
              ],
            ],
          ),
        );
      },
    );
  }

  String _title(AppLocalizations t, PaymentMethodEntity? paymentMethodEntity) {
    switch (paymentMethodEntity?.id) {
      case 28:
        return t.lblAccountBalance;
      default:
        return paymentMethodEntity?.name ?? '-';
    }
  }

  String _serviceFee(PaymentMethodEntity? paymentMethodEntity) {
    switch (paymentMethodEntity?.type?.toLowerCase()) {
      case 'e-money':
      case 'e-wallet':
      case 'lainnya':
      case 'debit online':
      case 'qris':
        return 'Biaya Layanan ${paymentMethodEntity?.percentageServiceFee}%';
      case 'virtual account':
      case 'offline':
        return 'Biaya Layanan Rp ${paymentMethodEntity?.nominalServiceFee?.toIdr() ?? '-'}';
      default:
        return 'Saldo Rp ${paymentMethodEntity?.accountBalance?.toIdr() ?? '0'}';
    }
  }

  double _serviceFeeOnDetailsOrder(PaymentMethodEntity? paymentMethodEntity,
      CheckoutEntity? checkoutEntity) {
    switch (paymentMethodEntity?.type?.toLowerCase()) {
      case 'e-money':
      case 'e-wallet':
      case 'lainnya':
      case 'debit online':
      case 'qris':
        double total =
            (double.tryParse(checkoutEntity?.grossAmount ?? '') ?? 0) +
                (paymentMethodEntity?.nominalServiceFee ?? 0).toDouble();
        double normalServiceFee =
            (paymentMethodEntity?.percentageServiceFee ?? 0) / 100;
        double serviceFee = (total / (1 - normalServiceFee)) - total;
        return serviceFee;
      default:
        return paymentMethodEntity?.nominalServiceFee?.toDouble() ?? 0;
    }
  }

  Widget _accountBalanceWidget(AppLocalizations t,
      PaymentCbtState paymentCbtState, bool isElite, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 33,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        Text(
          t.lblYourAccountBalanceIsUsed,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rp ${paymentCbtState.checkoutEntity?.grossAmount.toIdr()}',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
      ],
    );
  }

  Widget _ovoWidget(
      AppLocalizations t,
      PaymentCbtState paymentCbtState,
      bool isElite,
      GlobalKey<State<StatefulWidget>> formKey,
      BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 33,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        Text(
          t.lblNumberLinkedTo(paymentCbtState.paymentMethodEntity?.name ?? '-'),
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 8),
        Form(
          key: formKey,
          child: MainTextField(
            // controller: TextEditingController(text: ''),
            initialValue: context.read<PaymentCubit>().state.ovoPhoneNumber,
            hintText: t.lblInputYourPhoneNumber,
            onChange: (value) {
              context.read<PaymentCubit>().addOvoPhoneNumber(value);
            },
            onFieldSubmitted: (_) {},
            textInputFormatter: [
              LengthLimitingTextInputFormatter(13),
              FilteringTextInputFormatter.digitsOnly,
            ],
            // isError: isError,
            isDarkMode: isElite,
            textInputType: TextInputType.number,
            validator: (value) {
              if ((value ?? '').isEmpty) {
                return t.lblCantBeEmpty;
              }
              bool isMobilePhone = ValidationUtils.mobilePhone(value ?? '');
              if (isMobilePhone != true) {
                return t.lblPhoneNumberError;
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}
