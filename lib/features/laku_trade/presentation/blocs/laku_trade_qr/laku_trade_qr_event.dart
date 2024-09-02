part of 'laku_trade_qr_bloc.dart';

sealed class LakuTradeQrEvent extends Equatable {
  const LakuTradeQrEvent();

  @override
  List<Object> get props => [];
}

class LakuTradeQrGetDataEvent extends LakuTradeQrEvent {
  final String? code;

  const LakuTradeQrGetDataEvent(this.code);

  @override
  List<Object> get props => [
        [code]
      ];
}
