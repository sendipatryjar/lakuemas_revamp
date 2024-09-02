part of 'coupon_bloc.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object> get props => [];
}

class CouponInitialState extends CouponState {}

class CouponLoadingState extends CouponState {}

class CouponSuccessState extends CouponState {
  final List<CouponEntity> coupons;

  const CouponSuccessState({this.coupons = const []});

  @override
  List<Object> get props => [coupons];
}

class CouponFailureState extends CouponState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const CouponFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
