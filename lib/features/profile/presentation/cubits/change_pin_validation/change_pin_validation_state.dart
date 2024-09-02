part of 'change_pin_validation_cubit.dart';

class ChangePinValidationState extends Equatable {
  final String? oldPinError;
  final String? newPinError;
  final String? newPinConfirmError;

  const ChangePinValidationState({
    this.oldPinError,
    this.newPinError,
    this.newPinConfirmError,
  });

  ChangePinValidationState copyWith({
    String? oldPinError,
    String? newPinError,
    String? newPinConfirmError,
  }) =>
      ChangePinValidationState(
        oldPinError: oldPinError ?? this.oldPinError,
        newPinError: newPinError ?? this.newPinError,
        newPinConfirmError: newPinConfirmError ?? this.newPinConfirmError,
      );

  @override
  List<Object> get props => [
        [oldPinError, newPinError, newPinConfirmError]
      ];
}
