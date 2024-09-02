import 'package:equatable/equatable.dart';

import 'lakusave_duration_entity.dart';
import 'lakusave_extend_entity.dart';
import 'lakusave_interest_entity.dart';
import '../../../_core/others/domain/entities/terms_and_conditions_entity.dart';

class GoldDepositEntity extends Equatable {
  final String? minimumBalance;
  final String? eliteMinimumBalance;
  final TermsAndConditionsEntity? termsAndConditionsEntity;
  final List<LakusaveDurationEntity> durations;
  final List<LakusaveExtendEntity> extendss;
  final List<LakusaveInterestEntity> interests;

  const GoldDepositEntity({
    this.minimumBalance,
    this.eliteMinimumBalance,
    this.termsAndConditionsEntity,
    this.durations = const [],
    this.extendss = const [],
    this.interests = const [],
  });

  @override
  List<Object?> get props => [
        minimumBalance,
        eliteMinimumBalance,
        termsAndConditionsEntity,
        durations,
        extendss,
        interests,
      ];
}
