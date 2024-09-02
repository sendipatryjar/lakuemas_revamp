import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/laku_save/domain/entities/gold_deposit_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_duration_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_extend_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_interest_entity.dart';
import 'package:lakuemas/features/_core/others/domain/entities/terms_and_conditions_entity.dart';

void main() {
  test(
    'gold deposit entity',
    () {
      TermsAndConditionsEntity? termsAndConditionsEntity =
          const TermsAndConditionsEntity(
        title: 'title',
        description: 'description',
      );
      List<LakusaveDurationEntity> durations = const [
        LakusaveDurationEntity(
          id: 1,
          duration: 4,
          type: 'type',
        ),
        LakusaveDurationEntity(
          id: 3,
          duration: 8,
          type: 'type',
        ),
        LakusaveDurationEntity(
          id: 3,
          duration: 12,
          type: 'type',
        ),
      ];
      List<LakusaveExtendEntity> extendss = const [
        LakusaveExtendEntity(
          id: 1,
          name: 'tidak perpanjang',
          description: 'description',
        ),
        LakusaveExtendEntity(
          id: 1,
          name: 'pokok',
          description: 'description',
        ),
        LakusaveExtendEntity(
          id: 1,
          name: 'pokok + modal',
          description: 'description',
        ),
      ];
      List<LakusaveInterestEntity> interests = const [
        LakusaveInterestEntity(
            id: 1,
            customerTypeId: 1,
            depositDurationId: 1,
            interest: 4,
            minimumBalance: 10,
            eliteMinimumBalance: 1,
            maximumBalance: 100,
            tax: 0,
            createdAt: 'createdAt',
            updatedAt: 'updatedAt'),
      ];

      var result = GoldDepositEntity(
        durations: durations,
        eliteMinimumBalance: '1',
        extendss: extendss,
        interests: interests,
        minimumBalance: '10',
        termsAndConditionsEntity: termsAndConditionsEntity,
      );

      expect(result, isNotNull);
      expect(result.durations, equals(durations));
      expect(result.eliteMinimumBalance, equals('1'));
      expect(result.extendss, equals(extendss));
      expect(result.interests, equals(interests));
      expect(result.minimumBalance, equals('10'));
      expect(result.termsAndConditionsEntity, equals(termsAndConditionsEntity));
    },
  );
}
