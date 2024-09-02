part of 'bank_me_bloc.dart';

sealed class BankMeEvent extends Equatable {
  const BankMeEvent();

  @override
  List<Object> get props => [];
}

class BankMeGetEvent extends BankMeEvent {
  final HelperDataCubit helperDataCubit;

  const BankMeGetEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}
