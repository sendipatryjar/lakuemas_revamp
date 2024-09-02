import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/profile/data/models/change_password_req.dart';

void main() {
  Map<String, dynamic> reqData = {};

  group('change password req', () {
    setUp(() {
      reqData = {
        "old_password": "qwerty",
        "new_password": "123123",
        "confirm_password": "123123",
      };
    });
    test(
      'to json',
      () {
        const data = ChangePasswordReq(
          oldPassword: 'qwerty',
          newPassword: '123123',
          confirmPassword: '123123',
        );
        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
