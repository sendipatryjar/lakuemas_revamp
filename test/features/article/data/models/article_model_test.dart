import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/article/data/models/article_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'title': 'title',
      'page_title': 'pageTitle',
      'permalink': 'permalink',
      'sm_text': 'smText',
      'mid_text': 'midText',
      'content': 'content',
      'image': 'image',
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

  group('article model', () {
    test(
      'from json',
      () {
        final result = ArticleModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.id, equals(1));
        expect(result.title, equals('title'));
        expect(result.pageTitle, equals('pageTitle'));
        expect(result.permalink, equals('permalink'));
        expect(result.smText, equals('smText'));
        expect(result.midText, equals('midText'));
        expect(result.content, equals('content'));
        expect(result.image, equals('image'));
        expect(result.createdAt, equals('createdAt'));
        expect(result.updatedAt, equals('updatedAt'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = ArticleModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('checkout model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<ArticleModel>.fromJson(baseResp, ArticleModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.id, equals(1));
        expect(result.data?.title, equals('title'));
        expect(result.data?.pageTitle, equals('pageTitle'));
        expect(result.data?.permalink, equals('permalink'));
        expect(result.data?.smText, equals('smText'));
        expect(result.data?.midText, equals('midText'));
        expect(result.data?.content, equals('content'));
        expect(result.data?.image, equals('image'));
        expect(result.data?.createdAt, equals('createdAt'));
        expect(result.data?.updatedAt, equals('updatedAt'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<ArticleModel> fromJson =
            BaseResp.fromJson(baseResp, ArticleModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
