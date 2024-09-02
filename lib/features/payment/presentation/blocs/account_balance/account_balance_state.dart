part of 'account_balance_bloc.dart';

abstract class AccountBalanceState extends Equatable {
  const AccountBalanceState();

  @override
  List<Object> get props => [];
}

class AccountBalanceInitialState extends AccountBalanceState {}

class AccountBalanceLoadingState extends AccountBalanceState {}

class AccountBalanceSuccessState extends AccountBalanceState {
  final BalanceEntity balanceEntity;

  const AccountBalanceSuccessState(this.balanceEntity);

  @override
  List<Object> get props => [balanceEntity];
}

class AccountBalanceFailureState extends AccountBalanceState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const AccountBalanceFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
