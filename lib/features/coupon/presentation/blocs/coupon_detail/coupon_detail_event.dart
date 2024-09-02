part of 'coupon_detail_bloc.dart';

abstract class CouponDetailEvent extends Equatable {
  const CouponDetailEvent();

  @override
  List<Object> get props => [];
}

class CouponDetailGetEvent extends CouponDetailEvent {
  final String couponCode;

  const CouponDetailGetEvent(this.couponCode);

  @override
  List<Object> get props => [couponCode];
}

class CouponDetailInitEvent extends CouponDetailEvent {}
