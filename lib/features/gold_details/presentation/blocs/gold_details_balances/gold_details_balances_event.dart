part of 'gold_details_balances_bloc.dart';

abstract class GoldDetailsBalancesEvent extends Equatable {
  const GoldDetailsBalancesEvent();

  @override
  List<Object> get props => [];
}

class GoldDetailsBalancesGetEvent extends GoldDetailsBalancesEvent {}
