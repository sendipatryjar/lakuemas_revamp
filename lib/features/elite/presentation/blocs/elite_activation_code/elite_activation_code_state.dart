part of 'elite_activation_code_bloc.dart';

abstract class EliteActivationCodeState extends Equatable {
  const EliteActivationCodeState();

  @override
  List<Object> get props => [];
}

class EliteActivationCodeInitial extends EliteActivationCodeState {}

class EliteActivationCodeLoadingState extends EliteActivationCodeState {}

class EliteActivationCodeSuccessState extends EliteActivationCodeState {
  final EliteActivationCodeValidationEntity eliteActivationCodeValidationEntity;

  const EliteActivationCodeSuccessState(
      this.eliteActivationCodeValidationEntity);

  @override
  List<Object> get props => [
        [eliteActivationCodeValidationEntity]
      ];
}

class EliteActivationCodeFailureState extends EliteActivationCodeState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const EliteActivationCodeFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
