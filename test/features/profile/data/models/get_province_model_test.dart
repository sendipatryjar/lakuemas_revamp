import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/profile/data/models/get_Province_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};
  Map<String, dynamic> resDataCompare = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'name': 'Jakarta',
      'created_at': '01-12-2004',
      'updated_at': '01-12-2004',
    };
    resDataCompare = {
      'id': 1,
      'name': 'Jakarta',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('get Province model', () {
    test(
      'from json',
      () {
        final result = GetProvinceModel.fromJson(resData);
        expect(result.id, equals(1));
        expect(result.name, equals('Jakarta'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = GetProvinceModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resDataCompare));
      },
    );
  });

  group('get Province model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<GetProvinceModel>.fromJson(
            baseResp, GetProvinceModel.fromJson);
        expect(result.data?.id, equals(1));
        expect(result.data?.name, equals('Jakarta'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<GetProvinceModel> fromJson =
            BaseResp.fromJson(baseResp, GetProvinceModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resDataCompare));
      },
    );
  });
}
