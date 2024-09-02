part of 'change_username_validation_cubit.dart';

class ChangeUsernameValidationState extends Equatable {
  final String? phoneNumber;
  final String? email;
  final String? phoneNumberError;
  final String? emailError;

  const ChangeUsernameValidationState({
    this.phoneNumber,
    this.email,
    this.phoneNumberError,
    this.emailError,
  });

  ChangeUsernameValidationState copyWith({
    final String? phoneNumber,
    final String? email,
    final String? phoneNumberError,
    final bool nullifyPhoneNumberError = false,
    final String? emailError,
    final bool nullifyEmailError = false,
  }) =>
      ChangeUsernameValidationState(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        phoneNumberError: nullifyPhoneNumberError
            ? null
            : (phoneNumberError ?? this.phoneNumberError),
        emailError: nullifyEmailError ? null : (emailError ?? this.emailError),
      );

  @override
  List<Object?> get props => [phoneNumber, email, phoneNumberError, emailError];
}
