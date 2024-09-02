part of 'balance_bloc.dart';

abstract class BerandaBalancesState extends Equatable {
  const BerandaBalancesState();

  @override
  List<Object> get props => [];
}

class BerandaBalancesInitialState extends BerandaBalancesState {}

class BerandaBalancesLoadingState extends BerandaBalancesState {}

class BerandaBalancesSuccessState extends BerandaBalancesState {
  final BalanceEntity? goldBalanceEntity;
  final BalanceEntity? accountBalanceEntity;
  final double? lakusaveBalance;

  const BerandaBalancesSuccessState({
    this.goldBalanceEntity,
    this.accountBalanceEntity,
    this.lakusaveBalance,
  });

  @override
  List<Object> get props => [
        [goldBalanceEntity, accountBalanceEntity, lakusaveBalance]
      ];
}

class BerandaBalancesFailureState extends BerandaBalancesState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const BerandaBalancesFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
