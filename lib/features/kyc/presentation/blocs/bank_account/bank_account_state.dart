part of 'bank_account_bloc.dart';

abstract class BankAccountState extends Equatable {
  const BankAccountState();

  @override
  List<Object> get props => [];
}

class BankAccountInitial extends BankAccountState {}

class BankAccountLoadingState extends BankAccountState {}

class BankAccountSuccessState extends BankAccountState {}

class BankAccountFailureState extends BankAccountState {
  final int? code;
  final String? message;

  const BankAccountFailureState(this.code, this.message);

  @override
  List<Object> get props => [
        [code, message]
      ];
}
