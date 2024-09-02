import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/login/data/models/login_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> loginData = {};

  setUpAll(() {
    loginData = {
      "access_token": "accesstoken",
      "refresh_token": "refreshtoken",
      "phone_number": "08123456789",
      "email": "jhon.doe@email.com",
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": loginData,
    };
  });

  group('login model', () {
    test(
      'from json',
      () {
        final result = LoginModel.fromJson(loginData);
        expect(result.accessToken, equals('accesstoken'));
        expect(result.refreshToken, equals('refreshtoken'));
        expect(result.phoneNumber, equals('08123456789'));
        expect(result.email, equals('jhon.doe@email.com'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = LoginModel.fromJson(loginData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(loginData));
      },
    );
  });

  group('login model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<LoginModel>.fromJson(baseResp, LoginModel.fromJson);
        expect(result.data?.accessToken, equals('accesstoken'));
        expect(result.data?.refreshToken, equals('refreshtoken'));
        expect(result.data?.phoneNumber, equals('08123456789'));
        expect(result.data?.email, equals('jhon.doe@email.com'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<LoginModel> fromJson =
            BaseResp.fromJson(baseResp, LoginModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(loginData));
      },
    );
  });
}
