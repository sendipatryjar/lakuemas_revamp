import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/laku_save/data/models/lakusave_interest_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'deposit_duration_id': 1,
      'customer_type_id': 1,
      'interest': 3.0,
      'tax': 0.0,
      'minimum_balance': 10.0,
      'elite_minimum_balance': 1.0,
      'maximum_balance': 100.0,
      'created_at': 'createdAt',
      'updated_at': 'updatedAt',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('lakusave interest model', () {
    test(
      'from json',
      () {
        final result = LakusaveInterestModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.id, equals(1));
        expect(result.depositDurationId, equals(1));
        expect(result.customerTypeId, equals(1));
        expect(result.interest, equals(3.0));
        expect(result.tax, equals(0.0));
        expect(result.minimumBalance, equals(10.0));
        expect(result.eliteMinimumBalance, equals(1.0));
        expect(result.maximumBalance, equals(100.0));
        expect(result.createdAt, equals('createdAt'));
        expect(result.updatedAt, equals('updatedAt'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = LakusaveInterestModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('lakusave interest model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<LakusaveInterestModel>.fromJson(
            baseResp, LakusaveInterestModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.id, equals(1));
        expect(result.data?.depositDurationId, equals(1));
        expect(result.data?.customerTypeId, equals(1));
        expect(result.data?.interest, equals(3.0));
        expect(result.data?.tax, equals(0.0));
        expect(result.data?.minimumBalance, equals(10.0));
        expect(result.data?.eliteMinimumBalance, equals(1.0));
        expect(result.data?.maximumBalance, equals(100.0));
        expect(result.data?.createdAt, equals('createdAt'));
        expect(result.data?.updatedAt, equals('updatedAt'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<LakusaveInterestModel> fromJson =
            BaseResp.fromJson(baseResp, LakusaveInterestModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
