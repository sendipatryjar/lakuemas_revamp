import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/profile/data/models/get_District_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};
  Map<String, dynamic> resDataCompare = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'name': 'Jakarta',
      'city_id': 1,
      'created_at': '01-12-2004',
      'updated_at': '01-12-2004',
    };
    resDataCompare = {
      'id': 1,
      'name': 'Jakarta',
      'city_id': 1,
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('get district model', () {
    test(
      'from json',
      () {
        final result = GetDistrictModel.fromJson(resData);
        expect(result.id, equals(1));
        expect(result.name, equals('Jakarta'));
        expect(result.cityId, equals(1));
      },
    );
    test(
      'to json',
      () {
        final fromJson = GetDistrictModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resDataCompare));
      },
    );
  });

  group('get district model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<GetDistrictModel>.fromJson(
            baseResp, GetDistrictModel.fromJson);
        expect(result.data?.id, equals(1));
        expect(result.data?.name, equals('Jakarta'));
        expect(result.data?.cityId, equals(1));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<GetDistrictModel> fromJson =
            BaseResp.fromJson(baseResp, GetDistrictModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resDataCompare));
      },
    );
  });
}
