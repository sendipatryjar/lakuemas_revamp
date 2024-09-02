part of 'elite_referal_validation_bloc.dart';

abstract class EliteReferalValidationEvent extends Equatable {
  const EliteReferalValidationEvent();

  @override
  List<Object> get props => [];
}

class EliteReferalValidationSuccessEvent extends EliteReferalValidationEvent {
  final dynamic referalCode;

  const EliteReferalValidationSuccessEvent(
    this.referalCode,
  );

  @override
  List<Object> get props => [
        [referalCode]
      ];
}
