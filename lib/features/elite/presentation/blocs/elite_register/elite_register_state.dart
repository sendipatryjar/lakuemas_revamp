part of 'elite_register_bloc.dart';

abstract class EliteRegisterState extends Equatable {
  const EliteRegisterState();

  @override
  List<Object> get props => [];
}

class EliteRegisterInitial extends EliteRegisterState {}

class EliteRegisterLoadingState extends EliteRegisterState {}

class EliteRegisterSuccessState extends EliteRegisterState {
  final EliteRegisterEntity eliteRegisterEntity;

  const EliteRegisterSuccessState(this.eliteRegisterEntity);

  @override
  List<Object> get props => [
        [eliteRegisterEntity]
      ];
}

class EliteRegisterFailureState extends EliteRegisterState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const EliteRegisterFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
