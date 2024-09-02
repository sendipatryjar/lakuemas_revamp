import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/redeem/data/models/voucher_redeem_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'name': 'name',
      'code': 'code',
      'amount': '100025',
      'gold_amount': '5.0',
      'selling_price': '970000',
      'purchase_price': '980000',
      'tax': '0',
      'gold_redeemed': '5.0',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('voucher redeem model', () {
    test(
      'from json',
      () {
        final result = VoucherRedeemModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.code, equals('code'));
        expect(result.goldRedeemed, equals('5.0'));
        expect(result.name, equals('name'));
        expect(result.purchasePrice, equals('980000'));
        expect(result.sellingPrice, equals('970000'));
        expect(result.tax, equals('0'));
        expect(result.amount, equals('100025'));
        expect(result.goldAmount, equals('5.0'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = VoucherRedeemModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('voucher redeem model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<VoucherRedeemModel>.fromJson(
            baseResp, VoucherRedeemModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.code, equals('code'));
        expect(result.data?.goldRedeemed, equals('5.0'));
        expect(result.data?.name, equals('name'));
        expect(result.data?.purchasePrice, equals('980000'));
        expect(result.data?.sellingPrice, equals('970000'));
        expect(result.data?.tax, equals('0'));
        expect(result.data?.amount, equals('100025'));
        expect(result.data?.goldAmount, equals('5.0'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<VoucherRedeemModel> fromJson =
            BaseResp.fromJson(baseResp, VoucherRedeemModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
