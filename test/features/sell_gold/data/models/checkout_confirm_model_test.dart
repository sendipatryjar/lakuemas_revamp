import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/sell_gold/data/models/checkout_confirm_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'transaction_id': 1,
      'transaction_code': "transactionCode",
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('checkout confirm model', () {
    test(
      'from json',
      () {
        final result = CheckoutConfirmModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.transactionId, equals(1));
        expect(result.transactionCode, equals('transactionCode'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = CheckoutConfirmModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('checkout confirm model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<CheckoutConfirmModel>.fromJson(
            baseResp, CheckoutConfirmModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.transactionId, equals(1));
        expect(result.data?.transactionCode, equals('transactionCode'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<CheckoutConfirmModel> fromJson =
            BaseResp.fromJson(baseResp, CheckoutConfirmModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
