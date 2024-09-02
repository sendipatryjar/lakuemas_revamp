part of 'forgot_pin_validation_cubit.dart';

class ForgotPinValidationState extends Equatable {
  final bool? isEmailError;
  final String? emailErrorMessages;
  final bool? isPhoneError;
  final String? phoneErrorMessages;
  final String? newPin;
  final String? confirmPin;
  final String? isPinNotSame;
  final bool? isPinError;

  const ForgotPinValidationState({
    this.isEmailError = false,
    this.emailErrorMessages,
    this.isPhoneError = false,
    this.phoneErrorMessages,
    this.newPin,
    this.confirmPin,
    this.isPinNotSame,
    this.isPinError = false,
  });

  ForgotPinValidationState copyWith({
    bool? isEmailError,
    String? emailErrorMessages,
    bool? isPhoneError,
    String? phoneErrorMessages,
    String? newPin,
    String? confirmPin,
    String? isPinNotSame,
    bool? isPinError,
  }) =>
      ForgotPinValidationState(
        isEmailError: isEmailError ?? this.isEmailError,
        emailErrorMessages: emailErrorMessages ?? this.emailErrorMessages,
        isPhoneError: isPhoneError ?? this.isPhoneError,
        phoneErrorMessages: phoneErrorMessages ?? this.phoneErrorMessages,
        newPin: newPin ?? this.newPin,
        confirmPin: confirmPin ?? this.confirmPin,
        isPinNotSame: isPinNotSame ?? this.isPinNotSame,
        isPinError: isPinError ?? this.isPinError,
      );

  @override
  List<Object> get props => [
        [
          isEmailError,
          emailErrorMessages,
          isPhoneError,
          phoneErrorMessages,
          newPin,
          confirmPin,
          isPinNotSame,
          isPinError,
        ]
      ];
}
