import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/transfer/data/models/transfer_charge_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUp(() {
    resData = {
      'account_name': 'abogoboga',
      'account_number': '111111111',
      'gold_weight': '10',
      'transaction_key': 'PRE111111',
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
      final result = TransferChargeModel.fromJson(resData);

      expect(result, isNotNull);
      expect(result.accountName, equals('abogoboga'));
      expect(result.accountNumber, equals('111111111'));
      expect(result.goldWeight, equals('10'));
      expect(result.transactionKey, equals('PRE111111'));
    });

    test('to json', () {
      final fromJson = TransferChargeModel.fromJson(resData);
      final result = fromJson.toJson();

      expect(result, isNotNull);
      expect(result, equals(resData));
    });
  });

  group('transfer charge Model with base resp', () {
    test('from json', () {
      final result = BaseResp<TransferChargeModel>.fromJson(
          baseResp, TransferChargeModel.fromJson);

      expect(result, isNotNull);
      expect(result.data?.accountName, equals('abogoboga'));
      expect(result.data?.accountNumber, equals('111111111'));
      expect(result.data?.goldWeight, equals('10'));
      expect(result.data?.transactionKey, equals('PRE111111'));
    });

    test('to json', () {
      final BaseResp<TransferChargeModel> fromJson = BaseResp.fromJson(
        baseResp,
        TransferChargeModel.fromJson,
      );

      final result = fromJson.data?.toJson();
      expect(result, isNotNull);
      expect(result, equals(resData));
    });
  });
}
