import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/register/data/models/register_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> registerData = {};

  setUpAll(() {
    registerData = {
      "id": 1,
      "name": "jhon doe",
      "phone_number": "08123456789",
      "email": "jhon.doe@email.com",
      "created_at": '2019-08-24T14:15:22Z',
      "updated_at": '2019-08-24T14:15:22Z',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": registerData,
    };
  });

  group('register model', () {
    test(
      'from json',
      () {
        final result = RegisterModel.fromJson(registerData);
        expect(result.id, equals(1));
        expect(result.name, equals('jhon doe'));
        expect(result.phoneNumber, equals('08123456789'));
        expect(result.email, equals('jhon.doe@email.com'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = RegisterModel.fromJson(registerData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(registerData));
      },
    );
  });

  group('register model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<RegisterModel>.fromJson(baseResp, RegisterModel.fromJson);
        expect(result.data?.id, equals(1));
        expect(result.data?.name, equals('jhon doe'));
        expect(result.data?.phoneNumber, equals('08123456789'));
        expect(result.data?.email, equals('jhon.doe@email.com'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<RegisterModel> fromJson =
            BaseResp.fromJson(baseResp, RegisterModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(registerData));
      },
    );
  });
}
