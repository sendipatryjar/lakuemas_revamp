import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/beranda/data/models/menu_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'name': 'name',
      'description': 'description',
      'parent_id': 1,
      'position': 1,
      'is_active': 1,
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

  group('menu model', () {
    test(
      'from json',
      () {
        final result = MenuModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.id, equals(1));
        expect(result.name, equals('name'));
        expect(result.description, equals('description'));
        expect(result.parentId, equals(1));
        expect(result.position, equals(1));
        expect(result.isActive, equals(1));
        expect(result.createdAt, equals('createdAt'));
        expect(result.updatedAt, equals('updatedAt'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = MenuModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('menu model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<MenuModel>.fromJson(baseResp, MenuModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.id, equals(1));
        expect(result.data?.name, equals('name'));
        expect(result.data?.description, equals('description'));
        expect(result.data?.parentId, equals(1));
        expect(result.data?.position, equals(1));
        expect(result.data?.isActive, equals(1));
        expect(result.data?.createdAt, equals('createdAt'));
        expect(result.data?.updatedAt, equals('updatedAt'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<MenuModel> fromJson =
            BaseResp.fromJson(baseResp, MenuModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
