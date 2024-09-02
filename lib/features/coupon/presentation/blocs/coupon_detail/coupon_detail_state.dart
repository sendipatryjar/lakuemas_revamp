part of 'coupon_detail_bloc.dart';

abstract class CouponDetailState extends Equatable {
  const CouponDetailState();

  @override
  List<Object> get props => [];
}

class CouponDetailInitialState extends CouponDetailState {}

class CouponDetailLoadingState extends CouponDetailState {}

class CouponDetailSuccessState extends CouponDetailState {
  final CouponDetailEntity couponDetail;

  const CouponDetailSuccessState({required this.couponDetail});

  @override
  List<Object> get props => [couponDetail];
}

class CouponDetailFailureState extends CouponDetailState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const CouponDetailFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
