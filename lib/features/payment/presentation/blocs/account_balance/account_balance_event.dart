part of 'account_balance_bloc.dart';

abstract class AccountBalanceEvent extends Equatable {
  const AccountBalanceEvent();

  @override
  List<Object> get props => [];
}

class AccountBalanceGetEvent extends AccountBalanceEvent {
  final HelperDataCubit helperDataCubit;

  const AccountBalanceGetEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}
