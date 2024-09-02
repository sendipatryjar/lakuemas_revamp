import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/_core/others/data/models/terms_and_conditions_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'title': 'title',
      'description': 'description',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('terms and conditions model', () {
    test(
      'from json',
      () {
        final result = TermsAndConditionsModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.title, equals('title'));
        expect(result.description, equals('description'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = TermsAndConditionsModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('terms and conditions model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<TermsAndConditionsModel>.fromJson(
            baseResp, TermsAndConditionsModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.title, equals('title'));
        expect(result.data?.description, equals('description'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<TermsAndConditionsModel> fromJson =
            BaseResp.fromJson(baseResp, TermsAndConditionsModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
