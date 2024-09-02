import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/sell_gold/domain/entities/checkout_confirm_entity.dart';

void main() {
  test(
    'checkout confirm entity',
    () {
      const result = CheckoutConfirmEntity(
        transactionId: 1,
        transactionCode: 'qwertasdfgzxcvb',
      );

      expect(result, isNotNull);
      expect(result.transactionId, equals(1));
      expect(result.transactionCode, equals('qwertasdfgzxcvb'));
    },
  );
}
