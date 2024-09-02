part of 'bank_account_bloc.dart';

abstract class BankAccountEvent extends Equatable {
  const BankAccountEvent();

  @override
  List<Object> get props => [];
}

class BankAccountKycPressedEvent extends BankAccountEvent {
  final String accountNumber;
  final int bankId;

  const BankAccountKycPressedEvent(this.accountNumber, this.bankId);

  @override
  List<Object> get props => [accountNumber, bankId];
}
