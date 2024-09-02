import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/laku_save/data/models/lakusave_extend_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'name': 'name',
      'description': 'description',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('lakusave extend model', () {
    test(
      'from json',
      () {
        final result = LakusaveExtendModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.id, equals(1));
        expect(result.name, equals('name'));
        expect(result.description, equals('description'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = LakusaveExtendModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('lakusave extend model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<LakusaveExtendModel>.fromJson(
            baseResp, LakusaveExtendModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.id, equals(1));
        expect(result.data?.name, equals('name'));
        expect(result.data?.description, equals('description'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<LakusaveExtendModel> fromJson =
            BaseResp.fromJson(baseResp, LakusaveExtendModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
