part of 'coupon_validation_bloc.dart';

abstract class CouponValidationState extends Equatable {
  const CouponValidationState();

  @override
  List<Object> get props => [];
}

class CouponValidationInitialState extends CouponValidationState {}

class CouponValidationLoadingState extends CouponValidationState {}

class CouponValidationSuccessState extends CouponValidationState {
  final bool? isValid;

  const CouponValidationSuccessState({this.isValid});

  @override
  List<Object> get props => [
        [isValid]
      ];
}

class CouponValidationFailureState extends CouponValidationState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const CouponValidationFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
