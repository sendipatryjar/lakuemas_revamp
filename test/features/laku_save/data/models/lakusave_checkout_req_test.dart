import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/laku_save/data/models/lakusave_checkout_req.dart';

void main() {
  Map<String, dynamic> reqData = {};

  group('lakusave checkout req', () {
    setUp(() {
      reqData = {
        'duration_id': 1,
        'extend_id': 1,
        'gold_weight': 2.0,
        'account_number': '123456789',
        'account_number_dest': '987654321',
      };
    });

    test(
      'to json',
      () {
        final data = LakusaveCheckoutReq(
          durationId: 1,
          extendedId: 1,
          goldWeight: 2.0,
          accountNumber: '123456789',
          accountNumberDest: '987654321',
        );
        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
