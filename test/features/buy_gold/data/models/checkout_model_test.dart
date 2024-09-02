import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/_core/transaction/data/models/checkout_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'amount': '100025',
      'gold_amount': '0.2',
      'purchase_price': '100000',
      'gross_amount': '100025',
      'nominal_tax': '0',
      'percentage_tax': '0',
      'transaction_key': 'qwertasdfgzxcvb',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('checkout model', () {
    test(
      'from json',
      () {
        final result = CheckoutModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.amount, equals('100025'));
        expect(result.goldAmount, equals('0.2'));
        expect(result.goldPrice, equals('100000'));
        expect(result.nominalTax, equals('0'));
        expect(result.percentageTax, equals('0'));
        expect(result.grossAmount, equals('100025'));
        expect(result.transactionKey, equals('qwertasdfgzxcvb'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = CheckoutModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('checkout model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<CheckoutModel>.fromJson(baseResp, CheckoutModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.amount, equals('100025'));
        expect(result.data?.goldAmount, equals('0.2'));
        expect(result.data?.goldPrice, equals('100000'));
        expect(result.data?.nominalTax, equals('0'));
        expect(result.data?.percentageTax, equals('0'));
        expect(result.data?.grossAmount, equals('100025'));
        expect(result.data?.transactionKey, equals('qwertasdfgzxcvb'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<CheckoutModel> fromJson =
            BaseResp.fromJson(baseResp, CheckoutModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
