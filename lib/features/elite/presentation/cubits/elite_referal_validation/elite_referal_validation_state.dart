part of 'elite_referal_validation_cubit.dart';

class EliteReferalValidationCubitState extends Equatable {
  final bool? isReferalError;
  final String? referalErrorMessages;

  const EliteReferalValidationCubitState(
      {this.isReferalError, this.referalErrorMessages});

  EliteReferalValidationCubitState copyWith({
    bool? isReferalError,
    String? referalErrorMessages,
  }) =>
      EliteReferalValidationCubitState(
        isReferalError: isReferalError ?? this.isReferalError,
        referalErrorMessages: referalErrorMessages ?? this.referalErrorMessages,
      );

  @override
  List<Object> get props => [
        [
          isReferalError,
          referalErrorMessages,
        ]
      ];
}
