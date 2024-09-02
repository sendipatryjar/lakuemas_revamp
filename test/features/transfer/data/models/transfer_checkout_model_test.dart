import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/transfer/data/models/transfer_checkout_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUp(() {
    resData = {
      'transaction_code': '111111111',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('transfer charge model', () {
    test('from json', () {
      final result = TransferCheckoutModel.fromJson(resData);

      expect(result, isNotNull);
      expect(result.transactionCode, equals('111111111'));
    });

    test('to json', () {
      final fromJson = TransferCheckoutModel.fromJson(resData);
      final result = fromJson.toJson();

      expect(result, isNotNull);
      expect(result, equals(resData));
    });
  });

  group('transfer charge Model with base resp', () {
    test('from json', () {
      final result = BaseResp<TransferCheckoutModel>.fromJson(
          baseResp, TransferCheckoutModel.fromJson);

      expect(result, isNotNull);
      expect(result.data?.transactionCode, equals('111111111'));
    });

    test('to json', () {
      final BaseResp<TransferCheckoutModel> fromJson = BaseResp.fromJson(
        baseResp,
        TransferCheckoutModel.fromJson,
      );

      final result = fromJson.data?.toJson();
      expect(result, isNotNull);
      expect(result, equals(resData));
    });
  });
}
