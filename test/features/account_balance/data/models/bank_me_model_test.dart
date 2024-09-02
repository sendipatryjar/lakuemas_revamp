import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/account_balance/data/models/bank_me_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'customer_id': 1,
      'name': 'name',
      'account_name': 'accountName',
      'account_number': 'accountNumber',
      'logo': 'logo',
      'service_fee': 'serviceFee',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('bank me model', () {
    test(
      'from json',
      () {
        final result = BankMeModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.id, equals(1));
        expect(result.customerId, equals(1));
        expect(result.name, equals('name'));
        expect(result.accountName, equals('accountName'));
        expect(result.accountNumber, equals('accountNumber'));
        expect(result.logo, equals('logo'));
        expect(result.serviceFee, equals('serviceFee'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = BankMeModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('bank me model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<BankMeModel>.fromJson(baseResp, BankMeModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.id, equals(1));
        expect(result.data?.customerId, equals(1));
        expect(result.data?.name, equals('name'));
        expect(result.data?.accountName, equals('accountName'));
        expect(result.data?.accountNumber, equals('accountNumber'));
        expect(result.data?.logo, equals('logo'));
        expect(result.data?.serviceFee, equals('serviceFee'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<BankMeModel> fromJson =
            BaseResp.fromJson(baseResp, BankMeModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
