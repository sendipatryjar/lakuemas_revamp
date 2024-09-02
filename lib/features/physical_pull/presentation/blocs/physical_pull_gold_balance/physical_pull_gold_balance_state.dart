part of 'physical_pull_gold_balance_bloc.dart';

abstract class PhysicalPullGoldBalanceState extends Equatable {
  const PhysicalPullGoldBalanceState();

  @override
  List<Object> get props => [];
}

class PhysicalPullGoldBalanceInitialState extends PhysicalPullGoldBalanceState {
}

class PhysicalPullGoldBalanceLoadingState extends PhysicalPullGoldBalanceState {
}

class PhysicalPullGoldBalanceSuccessState extends PhysicalPullGoldBalanceState {
  final BalanceEntity? goldBalanceEntity;

  const PhysicalPullGoldBalanceSuccessState({this.goldBalanceEntity});

  @override
  List<Object> get props => [
        [
          goldBalanceEntity,
        ]
      ];
}

class PhysicalPullGoldBalanceFailureState extends PhysicalPullGoldBalanceState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const PhysicalPullGoldBalanceFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
