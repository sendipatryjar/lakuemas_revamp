import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/laku_save/domain/entities/deposit_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/transaction_entity.dart';

void main() {
  test('transaction entity', () {
    DepositEntity depositEntity = const DepositEntity(
      accountNumber: '123456789',
      duration: '4',
      durationType: 'month',
      extendLabel: 'extendLabel',
      interest: 'interest',
      isEnableUpdateExtend: false,
      startDate: '12 Januari 2023',
      endDate: '12 Mei 2023',
    );

    var result = TransactionEntity(
      id: 1,
      code: 'code',
      goldWeight: '2.0',
      depositEntity: depositEntity,
      typeLabel: 'typeLabel',
      status: 1,
      statusLabel: 'statusLabel',
      createdAt: 'createdAt',
      updatedAt: 'updatedAt',
    );

    expect(result, isNotNull);
    expect(result.id, equals(1));
    expect(result.code, equals('code'));
    expect(result.goldWeight, equals('2.0'));
    expect(result.depositEntity, equals(depositEntity));
    expect(result.typeLabel, equals('typeLabel'));
    expect(result.status, equals(1));
    expect(result.statusLabel, equals('statusLabel'));
    expect(result.createdAt, equals('createdAt'));
    expect(result.updatedAt, equals('updatedAt'));
  });
}
