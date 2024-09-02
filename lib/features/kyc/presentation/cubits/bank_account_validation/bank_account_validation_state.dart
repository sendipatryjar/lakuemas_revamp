part of 'bank_account_validation_cubit.dart';

class BankAccountValidationState extends Equatable {
  final bool? isAccountNumberError;
  final String? accountNumberErrorMessages;
  final bool? isBankError;
  final String? bankErrorMessages;

  const BankAccountValidationState({
    this.isAccountNumberError,
    this.accountNumberErrorMessages,
    this.isBankError,
    this.bankErrorMessages,
  });

  BankAccountValidationState copyWith({
    bool? isAccountNumberError,
    String? accountNumberErrorMessages,
    bool? isBankError,
    String? bankErrorMessages,
  }) =>
      BankAccountValidationState(
        isAccountNumberError: isAccountNumberError ?? this.isAccountNumberError,
        accountNumberErrorMessages:
            accountNumberErrorMessages ?? this.accountNumberErrorMessages,
        isBankError: isBankError ?? this.isBankError,
        bankErrorMessages: bankErrorMessages ?? this.bankErrorMessages,
      );

  @override
  List<Object> get props => [
        [
          isAccountNumberError,
          accountNumberErrorMessages,
          isBankError,
          bankErrorMessages,
        ]
      ];
}
