part of 'elite_order_details_validation_cubit.dart';

class EliteOrderDetailsValidationState extends Equatable {
  final bool? isTermsConditionsChecked;

  const EliteOrderDetailsValidationState({
    this.isTermsConditionsChecked = false,
  });

  EliteOrderDetailsValidationState copyWith({
    bool? isTermsConditionsChecked,
  }) =>
      EliteOrderDetailsValidationState(
        isTermsConditionsChecked:
            isTermsConditionsChecked ?? this.isTermsConditionsChecked,
      );

  @override
  List<Object> get props => [
        [isTermsConditionsChecked]
      ];
}
