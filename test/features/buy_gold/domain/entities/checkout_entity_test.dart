import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/checkout_entity.dart';

void main() {
  test(
    'checkout entity',
    () {
      const result = CheckoutEntity(
        amount: '100025',
        goldAmount: '0.2',
        goldPrice: '100000',
        nominalTax: '0',
        percentageTax: '0',
        grossAmount: '100025',
        transactionKey: 'qwertasdfgzxcvb',
      );

      expect(result, isNotNull);
      expect(result.amount, equals('100025'));
      expect(result.goldAmount, equals('0.2'));
      expect(result.goldPrice, equals('100000'));
      expect(result.nominalTax, equals('0'));
      expect(result.percentageTax, equals('0'));
      expect(result.grossAmount, equals('100025'));
      expect(result.transactionKey, equals('qwertasdfgzxcvb'));
    },
  );
}
