import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/otp/data/models/send_otp_req.dart';

void main() {
  Map<String, dynamic> sendOtpReqData = {};

  group('send otp req email', () {
    setUp(() {
      sendOtpReqData = {
        "username": "jhon.doe@email.com",
        'otp_type': 0,
      };
    });
    test(
      'from json',
      () {
        final result = SendOtpReq.fromJson(sendOtpReqData);
        expect(result.username, equals('jhon.doe@email.com'));
        expect(result.otpType, equals(0));
      },
    );
    test(
      'to json',
      () {
        final fromJson = SendOtpReq.fromJson(sendOtpReqData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(sendOtpReqData));
      },
    );
  });

  group('send otp req phone', () {
    setUp(() {
      sendOtpReqData = {
        "username": "0812345678",
        'otp_type': 1,
      };
    });
    test(
      'from json',
      () {
        final result = SendOtpReq.fromJson(sendOtpReqData);
        expect(result.username, equals('0812345678'));
        expect(result.otpType, equals(1));
      },
    );
    test(
      'to json',
      () {
        final fromJson = SendOtpReq.fromJson(sendOtpReqData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(sendOtpReqData));
      },
    );
  });
}
