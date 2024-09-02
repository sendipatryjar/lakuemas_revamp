part of 'gold_details_balances_bloc.dart';

abstract class GoldDetailsBalancesState extends Equatable {
  const GoldDetailsBalancesState();

  @override
  List<Object> get props => [];
}

class GoldDetailsBalancesInitialState extends GoldDetailsBalancesState {}

class GoldDetailsBalanceLoadingState extends GoldDetailsBalancesState {}

class GoldDetailsBalanceSuccessState extends GoldDetailsBalancesState {
  final BalanceEntity? goldBalanceEntity;
  final List<BalanceEntity>? depositBalanceEntity;
  final String? totalDepBalance;
  final String? totalGold;
  final double? totalNominal;

  const GoldDetailsBalanceSuccessState({
    this.goldBalanceEntity,
    this.depositBalanceEntity,
    this.totalDepBalance,
    this.totalGold,
    this.totalNominal,
  });

  @override
  List<Object> get props => [
        [
          goldBalanceEntity,
          depositBalanceEntity,
          totalDepBalance,
          totalGold,
          totalNominal,
        ]
      ];
}

class GoldDetailsBalanceFailureState extends GoldDetailsBalancesState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GoldDetailsBalanceFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
