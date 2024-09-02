part of 'change_password_validation_cubit.dart';

class ChangePasswordValidationState extends Equatable {
  final String? oldPasswordError;
  final String? newPasswordError;
  final String? newPasswordConfirmError;

  const ChangePasswordValidationState({
    this.oldPasswordError,
    this.newPasswordError,
    this.newPasswordConfirmError,
  });

  ChangePasswordValidationState copyWith({
    String? oldPasswordError,
    String? newPasswordError,
    String? newPasswordConfirmError,
  }) =>
      ChangePasswordValidationState(
        oldPasswordError: oldPasswordError ?? this.oldPasswordError,
        newPasswordError: newPasswordError ?? this.newPasswordError,
        newPasswordConfirmError:
            newPasswordConfirmError ?? this.newPasswordConfirmError,
      );

  @override
  List<Object> get props => [
        [oldPasswordError, newPasswordError, newPasswordConfirmError]
      ];
}
