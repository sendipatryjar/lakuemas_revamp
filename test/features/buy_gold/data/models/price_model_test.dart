import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/_core/transaction/data/models/price_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'price': '990000',
      'selling_price': "947000",
      'elite_selling_price': '948000',
      'purchase_price': '990000',
      'elite_purchase_price': '980000',
      'tax_percentage': '3',
      'tax_nominal': '0',
      'minimum_nominal': '50000',
      'minimum_grammation': '0.0506',
      'placeholder_nominal': ['100000', '200000', '300000'],
      'placeholder_grammation': ['1.00', '2.00', '3.00']
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('price model', () {
    test(
      'from json',
      () {
        final result = PriceModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.price, equals('990000'));
        expect(result.sellingPrice, equals('947000'));
        expect(result.eliteSellingPrice, equals('948000'));
        expect(result.purchasePrice, equals('990000'));
        expect(result.elitePurchasePrice, equals('980000'));
        expect(result.taxPercentage, equals('3'));
        expect(result.taxNominal, equals('0'));
        expect(result.minimumNominal, equals('50000'));
        expect(result.minimumGrammation, equals('0.0506'));
        expect(
            result.placeholderNominal, equals(['100000', '200000', '300000']));
        expect(result.placeholderGrammation, equals(['1.00', '2.00', '3.00']));
      },
    );
    test(
      'to json',
      () {
        final fromJson = PriceModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('price model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<PriceModel>.fromJson(baseResp, PriceModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.price, equals('990000'));
        expect(result.data?.sellingPrice, equals('947000'));
        expect(result.data?.eliteSellingPrice, equals('948000'));
        expect(result.data?.purchasePrice, equals('990000'));
        expect(result.data?.elitePurchasePrice, equals('980000'));
        expect(result.data?.taxPercentage, equals('3'));
        expect(result.data?.taxNominal, equals('0'));
        expect(result.data?.minimumNominal, equals('50000'));
        expect(result.data?.minimumGrammation, equals('0.0506'));
        expect(result.data?.placeholderNominal,
            equals(['100000', '200000', '300000']));
        expect(result.data?.placeholderGrammation,
            equals(['1.00', '2.00', '3.00']));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<PriceModel> fromJson =
            BaseResp.fromJson(baseResp, PriceModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
