part of 'payment_cubit.dart';

class PaymentCbtState extends Equatable {
  final int? paymentMethodSelected;
  final PaymentMethodEntity? paymentMethodEntity;
  final CheckoutEntity? checkoutEntity;
  final CouponDetailEntity? couponDetailEntity;
  final String? couponErrMessage;
  final String? ovoPhoneNumber;
  final bool? isNpwpAlreadyKyc;
  final PaymentDebetEntity? paymentDebetEntity;
  final PaymentDebetEntityErr? paymentDebetEntityErr;

  const PaymentCbtState({
    this.paymentMethodSelected,
    this.paymentMethodEntity,
    this.checkoutEntity,
    this.couponDetailEntity,
    this.couponErrMessage,
    this.ovoPhoneNumber,
    this.isNpwpAlreadyKyc,
    this.paymentDebetEntity,
    this.paymentDebetEntityErr,
  });

  PaymentCbtState copyWith({
    int? paymentMethodSelected,
    bool nullifyPaymentMethod = false,
    PaymentMethodEntity? paymentMethodEntity,
    CheckoutEntity? checkoutEntity,
    bool nullifyCouponDetail = false,
    CouponDetailEntity? couponDetailEntity,
    String? couponErrMessage,
    bool nullifyCouponErrMessage = false,
    String? ovoPhoneNumber,
    bool? isNpwpAlreadyKyc,
    PaymentDebetEntity? paymentDebetEntity,
    PaymentDebetEntityErr? paymentDebetEntityErr,
    bool nullifyPaymentDebet = false,
  }) =>
      PaymentCbtState(
        paymentMethodSelected: nullifyPaymentMethod
            ? null
            : (paymentMethodSelected ?? this.paymentMethodSelected),
        paymentMethodEntity: paymentMethodEntity ?? this.paymentMethodEntity,
        checkoutEntity: checkoutEntity ?? this.checkoutEntity,
        couponDetailEntity: nullifyCouponDetail
            ? null
            : (couponDetailEntity ?? this.couponDetailEntity),
        couponErrMessage: nullifyCouponErrMessage
            ? null
            : (couponErrMessage ?? this.couponErrMessage),
        ovoPhoneNumber: ovoPhoneNumber ?? this.ovoPhoneNumber,
        isNpwpAlreadyKyc: isNpwpAlreadyKyc ?? this.isNpwpAlreadyKyc,
        paymentDebetEntity: nullifyPaymentDebet
            ? null
            : (paymentDebetEntity ?? this.paymentDebetEntity),
        paymentDebetEntityErr: nullifyPaymentDebet
            ? null
            : (paymentDebetEntityErr ?? this.paymentDebetEntityErr),
      );

  @override
  List<Object> get props => [
        [
          paymentMethodSelected,
          paymentMethodEntity,
          checkoutEntity,
          couponDetailEntity,
          couponErrMessage,
          ovoPhoneNumber,
          isNpwpAlreadyKyc,
          paymentDebetEntity,
          paymentDebetEntityErr,
        ]
      ];
}
