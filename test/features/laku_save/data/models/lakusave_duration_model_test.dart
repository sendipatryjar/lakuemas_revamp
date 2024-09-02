import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/laku_save/data/models/lakusave_duration_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'type': 'type',
      'duration': 4,
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('lakusave duration model', () {
    test(
      'from json',
      () {
        final result = LakusaveDurationModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.id, equals(1));
        expect(result.type, equals('type'));
        expect(result.duration, equals(4));
      },
    );
    test(
      'to json',
      () {
        final fromJson = LakusaveDurationModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('lakusave duration model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<LakusaveDurationModel>.fromJson(
            baseResp, LakusaveDurationModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.id, equals(1));
        expect(result.data?.type, equals('type'));
        expect(result.data?.duration, equals(4));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<LakusaveDurationModel> fromJson =
            BaseResp.fromJson(baseResp, LakusaveDurationModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
