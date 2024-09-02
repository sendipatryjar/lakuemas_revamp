import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/transfer/domain/entities/transfer_checkout_entity.dart';

void main() {
  test('transfer checkout entity', () {
    const result = TransferCheckoutEntity(
      transactionCode: 'PRE111111111',
    );

    expect(result, isNotNull);
    expect(result.transactionCode, equals('PRE111111111'));
  });
}
