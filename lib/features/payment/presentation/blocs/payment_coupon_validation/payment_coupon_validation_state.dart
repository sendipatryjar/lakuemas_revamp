part of 'payment_coupon_validation_bloc.dart';

abstract class PaymentCouponValidationState extends Equatable {
  const PaymentCouponValidationState();

  @override
  List<Object> get props => [];
}

class PaymentCouponValidationInitialState extends PaymentCouponValidationState {
}

class PaymentCouponValidationLoadingState extends PaymentCouponValidationState {
}

class PaymentCouponValidationSuccessState extends PaymentCouponValidationState {
  final bool? isValid;

  const PaymentCouponValidationSuccessState({this.isValid});

  @override
  List<Object> get props => [
        [isValid]
      ];
}

class PaymentCouponValidationFailureState extends PaymentCouponValidationState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const PaymentCouponValidationFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
