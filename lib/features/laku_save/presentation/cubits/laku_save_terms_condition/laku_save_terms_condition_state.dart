part of 'laku_save_terms_condition_cubit.dart';

class LakuSaveTermsConditionState extends Equatable {
  final bool? isTermsConditionsChecked;
  const LakuSaveTermsConditionState({this.isTermsConditionsChecked});

  LakuSaveTermsConditionState copyWith({
    bool? isTermsConditionsChecked,
  }) =>
      LakuSaveTermsConditionState(
        isTermsConditionsChecked:
            isTermsConditionsChecked ?? this.isTermsConditionsChecked,
      );

  @override
  List<Object> get props => [
        [isTermsConditionsChecked]
      ];
}
