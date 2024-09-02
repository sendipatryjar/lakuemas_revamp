import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/redeem/data/models/voucher_redeemed_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'transaction_id': 1,
      'status': 1,
      'status_label': 'statusLabel',
      'transaction_code': 'transactionCode',
      'gold_redeemed': '5.0',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('voucher redeemed model', () {
    test(
      'from json',
      () {
        final result = VoucherRedeemedModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.transactionId, equals(1));
        expect(result.transactionCode, equals('transactionCode'));
        expect(result.goldRedeemed, equals('5.0'));
        expect(result.status, equals(1));
        expect(result.statusLabel, equals('statusLabel'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = VoucherRedeemedModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('voucher redeemed model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<VoucherRedeemedModel>.fromJson(
            baseResp, VoucherRedeemedModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.transactionId, equals(1));
        expect(result.data?.transactionCode, equals('transactionCode'));
        expect(result.data?.goldRedeemed, equals('5.0'));
        expect(result.data?.status, equals(1));
        expect(result.data?.statusLabel, equals('statusLabel'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<VoucherRedeemedModel> fromJson =
            BaseResp.fromJson(baseResp, VoucherRedeemedModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
