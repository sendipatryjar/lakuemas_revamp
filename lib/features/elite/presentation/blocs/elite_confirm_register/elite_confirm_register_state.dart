part of 'elite_confirm_register_bloc.dart';

abstract class EliteConfirmRegisterState extends Equatable {
  const EliteConfirmRegisterState();

  @override
  List<Object> get props => [];
}

class EliteConfirmRegisterInitial extends EliteConfirmRegisterState {}

class EliteConfirmRegisterLoadingState extends EliteConfirmRegisterState {}

class EliteConfirmRegisterSuccessState extends EliteConfirmRegisterState {
  final EliteRegisterEntity eliteRegisterEntity;

  const EliteConfirmRegisterSuccessState(this.eliteRegisterEntity);

  @override
  List<Object> get props => [
        [eliteRegisterEntity]
      ];
}

class EliteConfirmRegisterFailureState extends EliteConfirmRegisterState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const EliteConfirmRegisterFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
