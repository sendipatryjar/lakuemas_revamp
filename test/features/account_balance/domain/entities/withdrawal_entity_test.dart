import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/account_balance/domain/entities/withdrawal_entity.dart';

void main() {
  test(
    'withdrawal entity',
    () {
      const result = WithdrawalEntity(
        transactionId: 1,
        status: 1,
        amount: '250000',
        grossAmount: '400000',
        serviceFee: '3000',
        transactionCode: 'transactionCode',
      );

      expect(result, isNotNull);
      expect(result.transactionId, equals(1));
      expect(result.status, equals(1));
      expect(result.amount, equals('250000'));
      expect(result.grossAmount, equals('400000'));
      expect(result.serviceFee, equals('3000'));
      expect(result.transactionCode, equals('transactionCode'));
    },
  );
}
