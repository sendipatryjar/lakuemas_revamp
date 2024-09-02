part of 'redeem_check_bloc.dart';

abstract class RedeemCheckEvent extends Equatable {
  const RedeemCheckEvent();

  @override
  List<Object> get props => [];
}

class RedeemCheckNowEvent extends RedeemCheckEvent {
  final String voucherCode;

  const RedeemCheckNowEvent(this.voucherCode);

  @override
  List<Object> get props => [voucherCode];
}

class RedeemCheckResetEvent extends RedeemCheckEvent {}
