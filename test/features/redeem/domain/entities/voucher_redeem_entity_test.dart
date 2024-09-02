import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/redeem/domain/entities/voucher_redeem_entity.dart';

void main() {
  test(
    'voucher redeem entity',
    () {
      const result = VoucherRedeemEntity(
        code: 'code',
        goldRedeemed: '5.0',
        name: 'name',
        purchasePrice: '980000',
        sellingPrice: '970000',
        tax: '0',
        amount: '100025',
        goldAmount: '0.2',
      );

      expect(result, isNotNull);
      expect(result.code, equals('code'));
      expect(result.goldRedeemed, equals('5.0'));
      expect(result.name, equals('name'));
      expect(result.purchasePrice, equals('980000'));
      expect(result.sellingPrice, equals('970000'));
      expect(result.tax, equals('0'));
      expect(result.amount, equals('100025'));
      expect(result.goldAmount, equals('0.2'));
    },
  );
}
