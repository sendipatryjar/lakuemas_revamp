part of 'elite_start_register_bloc.dart';

abstract class EliteStartRegisterState extends Equatable {
  const EliteStartRegisterState();

  @override
  List<Object> get props => [];
}

class EliteStartRegisterInitial extends EliteStartRegisterState {}

class EliteStartRegisterLoadingState extends EliteStartRegisterState {}

class EliteStartRegisterSuccessState extends EliteStartRegisterState {}

class EliteStartRegisterFailureState extends EliteStartRegisterState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const EliteStartRegisterFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
