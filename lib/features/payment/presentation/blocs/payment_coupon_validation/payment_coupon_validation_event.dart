part of 'payment_coupon_validation_bloc.dart';

abstract class PaymentCouponValidationEvent extends Equatable {
  const PaymentCouponValidationEvent();

  @override
  List<Object> get props => [];
}

class PaymentCouponValidationTriggerEvent extends PaymentCouponValidationEvent {
  final String couponCode;
  final int amount;
  final int paymentMethodId;

  const PaymentCouponValidationTriggerEvent({
    required this.couponCode,
    required this.amount,
    required this.paymentMethodId,
  });
}
