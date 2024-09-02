part of 'bgold_balance_bloc.dart';

abstract class BgoldBalanceEvent extends Equatable {
  const BgoldBalanceEvent();

  @override
  List<Object> get props => [];
}

class BgoldGetBalanceEvent extends BgoldBalanceEvent {
  final HelperDataCubit helperDataCubit;

  const BgoldGetBalanceEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}
