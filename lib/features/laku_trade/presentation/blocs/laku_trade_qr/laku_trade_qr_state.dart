part of 'laku_trade_qr_bloc.dart';

sealed class LakuTradeQrState extends Equatable {
  const LakuTradeQrState();

  @override
  List<Object> get props => [];
}

class LakuTradeQrInitialState extends LakuTradeQrState {}

class LakuTradeQrLoadingState extends LakuTradeQrState {}

class LakuTradeQrSuccessState extends LakuTradeQrState {
  final LakuTradeQrDataEntity? data;

  const LakuTradeQrSuccessState({required this.data});

  @override
  List<Object> get props => [
        [data]
      ];
}

class LakuTradeQrFailureState extends LakuTradeQrState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const LakuTradeQrFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
