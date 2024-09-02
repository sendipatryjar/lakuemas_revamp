import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/transfer/domain/entities/transfer_charge_entity.dart';

void main() {
  test('transfer charge entity', () {
    const result = TransferChargeEntity(
      accountName: 'abogoboga',
      accountNumber: '111111',
      goldWeight: '1',
      transactionKey: 'PRE10101010',
    );

    expect(result, isNotNull);
    expect(result.accountName, equals('abogoboga'));
    expect(result.accountNumber, equals('111111'));
    expect(result.goldWeight, equals('1'));
    expect(result.transactionKey, equals('PRE10101010'));
  });
}
