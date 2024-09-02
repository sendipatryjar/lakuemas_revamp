part of 'elite_referal_validation_bloc.dart';

abstract class EliteReferalValidationState extends Equatable {
  const EliteReferalValidationState();

  @override
  List<Object> get props => [];
}

class EliteReferalValidationInitial extends EliteReferalValidationState {}

class EliteReferalValidationLoadingState extends EliteReferalValidationState {}

class EliteReferalValidationSuccessState extends EliteReferalValidationState {
  final EliteReferalValidaitonEntity eliteReferalValidaitonEntity;

  const EliteReferalValidationSuccessState(this.eliteReferalValidaitonEntity);

  @override
  List<Object> get props => [
        [eliteReferalValidaitonEntity]
      ];
}

class EliteReferalValidationFailureState extends EliteReferalValidationState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const EliteReferalValidationFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
