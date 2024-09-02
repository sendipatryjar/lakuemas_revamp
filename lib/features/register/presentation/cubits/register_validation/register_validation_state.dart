part of 'register_validation_cubit.dart';

class RegisterValidationState extends Equatable {
  final bool? isFullNameError;
  final String? fullNameErrorMessages;
  final bool? isPhoneError;
  final String? phoneErrorMessages;
  final bool? isEmailError;
  final String? emailErrorMessages;
  final bool? isPasswordError;
  final String? passwordErrorMessages;
  final bool? isTermsConditionsChecked;
  final bool? isPrivacyPolicyChecked;

  const RegisterValidationState({
    this.isFullNameError = false,
    this.fullNameErrorMessages,
    this.isPhoneError = false,
    this.phoneErrorMessages,
    this.isEmailError = false,
    this.emailErrorMessages,
    this.isPasswordError = false,
    this.passwordErrorMessages,
    this.isTermsConditionsChecked = false,
    this.isPrivacyPolicyChecked = false,
  });

  RegisterValidationState copyWith({
    bool? isFullNameError,
    String? fullNameErrorMessages,
    bool? isPhoneError,
    String? phoneErrorMessages,
    bool? isEmailError,
    String? emailErrorMessages,
    bool? isPasswordError,
    String? passwordErrorMessages,
    bool? isReferalError,
    String? referalErrorMessages,
    bool? isTermsConditionsChecked,
    bool? isPrivacyPolicyChecked,
  }) =>
      RegisterValidationState(
        isFullNameError: isFullNameError ?? this.isFullNameError,
        fullNameErrorMessages:
            fullNameErrorMessages ?? this.fullNameErrorMessages,
        isPhoneError: isPhoneError ?? this.isPhoneError,
        phoneErrorMessages: phoneErrorMessages ?? this.phoneErrorMessages,
        isEmailError: isEmailError ?? this.isEmailError,
        emailErrorMessages: emailErrorMessages ?? this.emailErrorMessages,
        isPasswordError: isPasswordError ?? this.isPasswordError,
        passwordErrorMessages:
            passwordErrorMessages ?? this.passwordErrorMessages,
        isTermsConditionsChecked:
            isTermsConditionsChecked ?? this.isTermsConditionsChecked,
        isPrivacyPolicyChecked:
            isPrivacyPolicyChecked ?? this.isPrivacyPolicyChecked,
      );

  @override
  List<Object> get props => [
        [
          isFullNameError,
          fullNameErrorMessages,
          isPhoneError,
          phoneErrorMessages,
          isEmailError,
          emailErrorMessages,
          isPasswordError,
          passwordErrorMessages,
          isTermsConditionsChecked,
          isPrivacyPolicyChecked,
        ]
      ];
}
