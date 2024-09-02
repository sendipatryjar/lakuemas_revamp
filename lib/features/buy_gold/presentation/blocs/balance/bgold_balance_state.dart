part of 'bgold_balance_bloc.dart';

abstract class BgoldBalanceState extends Equatable {
  const BgoldBalanceState();

  @override
  List<Object> get props => [];
}

class BgoldBalanceInitialState extends BgoldBalanceState {}

class BgoldBalanceLoadingState extends BgoldBalanceState {}

class BgoldBalanceSuccessState extends BgoldBalanceState {
  final BalanceEntity? balanceEntity;

  const BgoldBalanceSuccessState({this.balanceEntity});

  @override
  List<Object> get props => [
        [balanceEntity]
      ];
}

class BgoldBalanceFailureState extends BgoldBalanceState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const BgoldBalanceFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
