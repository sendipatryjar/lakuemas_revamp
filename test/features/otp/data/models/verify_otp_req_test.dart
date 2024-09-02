import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/otp/data/models/verify_otp_req.dart';

void main() {
  Map<String, dynamic> verifyOtpReqData = {};

  group('verify otp req email', () {
    setUp(() {
      verifyOtpReqData = {
        "username": "jhon.doe@email.com",
        'otp_code': "123456",
      };
    });
    test(
      'from json',
      () {
        final result = VerifyOtpReq.fromJson(verifyOtpReqData);
        expect(result.username, equals('jhon.doe@email.com'));
        expect(result.otpCode, equals('123456'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = VerifyOtpReq.fromJson(verifyOtpReqData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(verifyOtpReqData));
      },
    );
  });

  group('send otp req phone', () {
    setUp(() {
      verifyOtpReqData = {
        "username": "0812345678",
        'otp_code': '123456',
      };
    });
    test(
      'from json',
      () {
        final result = VerifyOtpReq.fromJson(verifyOtpReqData);
        expect(result.username, equals('0812345678'));
        expect(result.otpCode, equals('123456'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = VerifyOtpReq.fromJson(verifyOtpReqData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(verifyOtpReqData));
      },
    );
  });
}
