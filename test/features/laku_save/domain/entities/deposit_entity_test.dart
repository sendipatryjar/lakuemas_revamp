import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/laku_save/domain/entities/deposit_entity.dart';

void main() {
  test(
    'deposit entity',
    () {
      const result = DepositEntity(
        accountNumber: '123456789',
        duration: '4',
        durationType: 'month',
        extendLabel: 'extendLabel',
        interest: 'interest',
        isEnableUpdateExtend: false,
        startDate: '12 Januari 2023',
        endDate: '12 Mei 2023',
      );

      expect(result, isNotNull);
      expect(result.accountNumber, equals('123456789'));
      expect(result.duration, equals('4'));
      expect(result.durationType, equals('month'));
      expect(result.extendLabel, equals('extendLabel'));
      expect(result.interest, equals('interest'));
      expect(result.isEnableUpdateExtend, equals(false));
      expect(result.startDate, equals('12 Januari 2023'));
      expect(result.endDate, equals('12 Mei 2023'));
    },
  );
}
