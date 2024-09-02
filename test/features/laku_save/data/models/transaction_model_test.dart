import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/laku_save/data/models/transaction_model.dart';
import 'package:lakuemas/features/laku_save/domain/entities/deposit_entity.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'id': 1,
      'status': 1,
      'gold_weight': '5.0',
      'type_label': 'typeLabel',
      'status_label': 'statusLabel',
      'code': 'code',
      'created_at': 'createdAt',
      'updated_at': 'updatedAt',
      'deposit': {
        'is_enable_update_extend': null,
        'account_number': '123456789',
        'interest': 'interest',
        'duration': 'duration',
        'duration_type': 'durationType',
        'extend_label': 'extendLabel',
        'start_date': 'startDate',
        'end_date': 'endDate',
      },
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('transaction model', () {
    test(
      'from json',
      () {
        final result = TransactionModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.id, equals(1));
        expect(result.status, equals(1));
        expect(result.goldWeight, equals('5.0'));
        expect(result.typeLabel, equals('typeLabel'));
        expect(result.statusLabel, equals('statusLabel'));
        expect(result.code, equals('code'));
        expect(result.createdAt, equals('createdAt'));
        expect(result.updatedAt, equals('updatedAt'));
        expect(result.depositEntity, isA<DepositEntity>());
      },
    );
    test(
      'to json',
      () {
        final fromJson = TransactionModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('transaction model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<TransactionModel>.fromJson(
            baseResp, TransactionModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.id, equals(1));
        expect(result.data?.status, equals(1));
        expect(result.data?.goldWeight, equals('5.0'));
        expect(result.data?.typeLabel, equals('typeLabel'));
        expect(result.data?.statusLabel, equals('statusLabel'));
        expect(result.data?.code, equals('code'));
        expect(result.data?.createdAt, equals('createdAt'));
        expect(result.data?.updatedAt, equals('updatedAt'));
        expect(result.data?.depositEntity, isA<DepositEntity>());
      },
    );
    test(
      'to json',
      () {
        final BaseResp<TransactionModel> fromJson =
            BaseResp.fromJson(baseResp, TransactionModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
