part of 'laku_trade_checkout_bloc.dart';

sealed class LakuTradeCheckoutState extends Equatable {
  const LakuTradeCheckoutState();

  @override
  List<Object> get props => [];
}

class LakuTradeCheckoutInitialState extends LakuTradeCheckoutState {}

class LakuTradeCheckoutLoadingState extends LakuTradeCheckoutState {}

class LakuTradeCheckoutSuccessState extends LakuTradeCheckoutState {
  final LakuTradeCheckoutEntity? data;

  const LakuTradeCheckoutSuccessState({required this.data});

  @override
  List<Object> get props => [
        [data]
      ];
}

class LakuTradeCheckoutFailureState extends LakuTradeCheckoutState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const LakuTradeCheckoutFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
