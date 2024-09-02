part of 'laku_trade_checkout_bloc.dart';

sealed class LakuTradeCheckoutEvent extends Equatable {
  const LakuTradeCheckoutEvent();

  @override
  List<Object> get props => [];
}

class LakuTradeCheckoutNowEvent extends LakuTradeCheckoutEvent {
  final String? qrcode;

  const LakuTradeCheckoutNowEvent(this.qrcode);
}
