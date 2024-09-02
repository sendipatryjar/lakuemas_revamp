import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/account_balance/data/models/withdrawal_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'transaction_id': 1,
      'status': 1,
      'amount': 'amount',
      'gross_amount': 'grossAmount',
      'service_fee': 'serviceFee',
      'transaction_code': 'transactionCode',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('withdrawal model', () {
    test(
      'from json',
      () {
        final result = WithdrawalModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.status, equals(1));
        expect(result.transactionId, equals(1));
        expect(result.amount, equals('amount'));
        expect(result.grossAmount, equals('grossAmount'));
        expect(result.serviceFee, equals('serviceFee'));
        expect(result.transactionCode, equals('transactionCode'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = WithdrawalModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('withdrawal model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<WithdrawalModel>.fromJson(
            baseResp, WithdrawalModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.status, equals(1));
        expect(result.data?.transactionId, equals(1));
        expect(result.data?.amount, equals('amount'));
        expect(result.data?.grossAmount, equals('grossAmount'));
        expect(result.data?.serviceFee, equals('serviceFee'));
        expect(result.data?.transactionCode, equals('transactionCode'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<WithdrawalModel> fromJson =
            BaseResp.fromJson(baseResp, WithdrawalModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
