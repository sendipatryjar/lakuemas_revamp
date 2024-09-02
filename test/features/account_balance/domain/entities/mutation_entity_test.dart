import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/account_balance/domain/entities/mutation_entity.dart';

void main() {
  test(
    'mutation entity',
    () {
      const result = MutationEntity(
        status: 1,
        walletId: 1,
        customerId: 1,
        transactionId: 1,
        code: 'code',
        type: 'type',
        mutationType: 'mutationType',
        amount: '250000',
        balance: '400000',
        transactionDate: '7 Sep 2023',
      );

      expect(result, isNotNull);
      expect(result.status, equals(1));
      expect(result.walletId, equals(1));
      expect(result.customerId, equals(1));
      expect(result.transactionId, equals(1));
      expect(result.code, equals('code'));
      expect(result.type, equals('type'));
      expect(result.mutationType, equals('mutationType'));
      expect(result.amount, equals('250000'));
      expect(result.balance, equals('400000'));
      expect(result.transactionDate, equals('7 Sep 2023'));
    },
  );
}
