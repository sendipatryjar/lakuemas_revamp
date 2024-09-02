part of 'forgot_password_validation_cubit.dart';

class ForgotPasswordValidationState extends Equatable {
  final bool? isEmailError;
  final String? emailErrorMessages;
  final bool? isPhoneError;
  final String? phoneErrorMessages;
  final String? newPassword;
  final String? newPasswordErrorMessage;
  final String? confirmPassword;
  final String? confirmPasswordErrorMessage;

  const ForgotPasswordValidationState({
    this.isEmailError = false,
    this.emailErrorMessages,
    this.isPhoneError = false,
    this.phoneErrorMessages,
    this.newPassword,
    this.newPasswordErrorMessage,
    this.confirmPassword,
    this.confirmPasswordErrorMessage,
  });

  ForgotPasswordValidationState copyWith({
    bool? isEmailError,
    String? emailErrorMessages,
    bool? isPhoneError,
    String? phoneErrorMessages,
    String? newPassword,
    String? newPasswordErrorMessage,
    bool nullifyNewPasswordErrorMessage = false,
    String? confirmPassword,
    String? confirmPasswordErrorMessage,
    bool nullifyConfirmPasswordErrorMessage = false,
  }) =>
      ForgotPasswordValidationState(
        isEmailError: isEmailError ?? this.isEmailError,
        emailErrorMessages: emailErrorMessages ?? this.emailErrorMessages,
        isPhoneError: isPhoneError ?? this.isPhoneError,
        phoneErrorMessages: phoneErrorMessages ?? this.phoneErrorMessages,
        newPassword: newPassword ?? this.newPassword,
        newPasswordErrorMessage: nullifyNewPasswordErrorMessage
            ? null
            : (newPasswordErrorMessage ?? this.newPasswordErrorMessage),
        confirmPassword: confirmPassword ?? this.confirmPassword,
        confirmPasswordErrorMessage: nullifyConfirmPasswordErrorMessage
            ? null
            : (confirmPasswordErrorMessage ?? this.confirmPasswordErrorMessage),
      );

  @override
  List<Object> get props => [
        [
          isEmailError,
          emailErrorMessages,
          isPhoneError,
          phoneErrorMessages,
          newPassword,
          newPasswordErrorMessage,
          confirmPassword,
          confirmPasswordErrorMessage,
        ]
      ];
}
