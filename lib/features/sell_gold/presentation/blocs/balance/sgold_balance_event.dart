part of 'sgold_balance_bloc.dart';

abstract class SgoldBalanceEvent extends Equatable {
  const SgoldBalanceEvent();

  @override
  List<Object> get props => [];
}

class SgoldGetBalanceEvent extends SgoldBalanceEvent {
  final HelperDataCubit helperDataCubit;

  const SgoldGetBalanceEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}
