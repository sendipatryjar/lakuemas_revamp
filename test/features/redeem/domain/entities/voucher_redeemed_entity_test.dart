import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/redeem/domain/entities/voucher_redeemed_entity.dart';

void main() {
  test(
    'voucher redeem entity',
    () {
      const result = VoucherRedeemedEntity(
        transactionId: 1,
        transactionCode: 'transactionCode',
        goldRedeemed: '5.0',
        status: 1,
        statusLabel: 'statusLabel',
      );

      expect(result, isNotNull);
      expect(result.transactionId, equals(1));
      expect(result.transactionCode, equals('transactionCode'));
      expect(result.goldRedeemed, equals('5.0'));
      expect(result.status, equals(1));
      expect(result.statusLabel, equals('statusLabel'));
    },
  );
}
