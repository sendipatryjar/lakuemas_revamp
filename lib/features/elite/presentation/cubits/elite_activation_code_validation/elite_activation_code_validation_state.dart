part of 'elite_activation_code_validation_cubit.dart';

class EliteActivationCodeValidationState extends Equatable {
  final bool? isActivationCodeError;
  final String? activationCodeErrorMessage;

  const EliteActivationCodeValidationState(
      {this.isActivationCodeError, this.activationCodeErrorMessage});

  EliteActivationCodeValidationState copyWith({
    bool? isActivationCodeError,
    String? activationCodeErrorMessage,
  }) =>
      EliteActivationCodeValidationState(
        isActivationCodeError:
            isActivationCodeError ?? this.isActivationCodeError,
        activationCodeErrorMessage:
            activationCodeErrorMessage ?? this.activationCodeErrorMessage,
      );

  @override
  List<Object> get props => [
        [
          isActivationCodeError,
          activationCodeErrorMessage,
        ]
      ];
}
