import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/profile/data/models/change_pin_req.dart';

void main() {
  Map<String, dynamic> reqData = {};

  group('change pin req', () {
    setUp(() {
      reqData = {
        "old_pin": "123456",
        "new_pin": "123123",
        "confirm_pin": "123123",
      };
    });
    test(
      'to json',
      () {
        const data = ChangePinReq(
          oldPin: '123456',
          newPin: '123123',
          confirmPin: '123123',
        );
        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
