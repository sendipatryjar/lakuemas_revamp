part of 'elite_me_bloc.dart';

sealed class EliteMeState extends Equatable {
  const EliteMeState();

  @override
  List<Object> get props => [];
}

class EliteMeInitial extends EliteMeState {}

class EliteMeLoadingState extends EliteMeState {}

class EliteMeSuccessState extends EliteMeState {
  final EliteMeEntity eliteMeEntity;

  const EliteMeSuccessState(this.eliteMeEntity);

  @override
  List<Object> get props => [
        [eliteMeEntity]
      ];
}

class EliteMeFailureState extends EliteMeState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const EliteMeFailureState(
    this.appFailure,
    this.code,
    this.message,
  );

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
