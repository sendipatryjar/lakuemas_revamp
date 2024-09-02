part of 'sgold_balance_bloc.dart';

abstract class SgoldBalanceState extends Equatable {
  const SgoldBalanceState();

  @override
  List<Object> get props => [];
}

class SgoldBalanceInitialState extends SgoldBalanceState {}

class SgoldBalanceLoadingState extends SgoldBalanceState {}

class SgoldBalanceSuccessState extends SgoldBalanceState {
  final BalanceEntity? balanceEntity;

  const SgoldBalanceSuccessState({this.balanceEntity});

  @override
  List<Object> get props => [
        [balanceEntity]
      ];
}

class SgoldBalanceFailureState extends SgoldBalanceState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const SgoldBalanceFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
