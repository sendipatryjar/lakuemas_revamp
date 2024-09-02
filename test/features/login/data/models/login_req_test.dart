import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/login/data/models/login_req.dart';

void main() {
  Map<String, dynamic> reqData = {};

  group('login req', () {
    setUp(() {
      reqData = {
        "username": "jhon.doe@email.com",
        'password': '123456',
        'firebase_token': '123qwe123asd',
      };
    });
    // test(
    //   'from json',
    //   () {
    //     final result = LoginReq.fromJson(sendOtpReqData);
    //     expect(result.username, equals('jhon.doe@email.com'));
    //     expect(result.otpType, equals(0));
    //   },
    // );
    test(
      'to json',
      () {
        final data = LoginReq(
          username: 'jhon.doe@email.com',
          password: '123456',
          firebaseToken: '123qwe123asd',
        );
        final result = data.toJson();
        expect(result, isNotNull);
        expect(result, equals(reqData));
      },
    );
  });
}
