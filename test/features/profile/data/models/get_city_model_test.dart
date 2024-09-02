import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/profile/data/models/get_city_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};
  Map<String, dynamic> resDataCompare = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'city': 'Jakarta',
      'province_id': 1,
      'created_at': '01-12-2004',
      'updated_at': '01-12-2004',
    };
    resDataCompare = {
      'id': 1,
      'city': 'Jakarta',
      'province_id': 1,
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('get city model', () {
    test(
      'from json',
      () {
        final result = GetCityModel.fromJson(resData);
        expect(result.id, equals(1));
        expect(result.city, equals('Jakarta'));
        expect(result.provinceId, equals(1));
      },
    );
    test(
      'to json',
      () {
        final fromJson = GetCityModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resDataCompare));
      },
    );
  });

  group('get city model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<GetCityModel>.fromJson(baseResp, GetCityModel.fromJson);
        expect(result.data?.id, equals(1));
        expect(result.data?.city, equals('Jakarta'));
        expect(result.data?.provinceId, equals(1));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<GetCityModel> fromJson =
            BaseResp.fromJson(baseResp, GetCityModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resDataCompare));
      },
    );
  });
}
