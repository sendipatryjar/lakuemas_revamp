import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/beranda/data/models/promo_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'title': 'title',
      'content': 'content',
      'image': 'imageUrl',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('promo model', () {
    test(
      'from json',
      () {
        final result = PromoModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.id, equals(1));
        expect(result.title, equals('title'));
        expect(result.content, equals('content'));
        expect(result.imageUrl, equals('imageUrl'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = PromoModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('promo model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<PromoModel>.fromJson(baseResp, PromoModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.id, equals(1));
        expect(result.data?.title, equals('title'));
        expect(result.data?.content, equals('content'));
        expect(result.data?.imageUrl, equals('imageUrl'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<PromoModel> fromJson =
            BaseResp.fromJson(baseResp, PromoModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
