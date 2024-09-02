import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_interest_entity.dart';

void main() {
  test('lakusave interest entity', () {
    const result = LakusaveInterestEntity(
      id: 1,
      customerTypeId: 1,
      depositDurationId: 1,
      interest: 4,
      minimumBalance: 10,
      eliteMinimumBalance: 1,
      maximumBalance: 100,
      tax: 0,
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    );

    expect(result, isNotNull);
    expect(result.id, equals(1));
    expect(result.customerTypeId, equals(1));
    expect(result.depositDurationId, equals(1));
    expect(result.interest, equals(4));
    expect(result.minimumBalance, equals(10));
    expect(result.eliteMinimumBalance, equals(1));
    expect(result.maximumBalance, equals(100));
    expect(result.tax, equals(0));
    expect(result.createdAt, equals('createdAt'));
    expect(result.updatedAt, equals('updatedAt'));
  });
}
