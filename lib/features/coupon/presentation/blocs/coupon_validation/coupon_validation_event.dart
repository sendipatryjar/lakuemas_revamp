part of 'coupon_validation_bloc.dart';

abstract class CouponValidationEvent extends Equatable {
  const CouponValidationEvent();

  @override
  List<Object> get props => [];
}

class CouponValidationTriggerEvent extends CouponValidationEvent {
  final String couponCode;
  final int amount;
  final int paymentMethodId;

  const CouponValidationTriggerEvent({
    required this.couponCode,
    required this.amount,
    required this.paymentMethodId,
  });
}
