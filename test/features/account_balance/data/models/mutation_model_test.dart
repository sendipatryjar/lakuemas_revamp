import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/account_balance/data/models/mutation_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'status': 1,
      'customer_id': 1,
      'wallet_id': 1,
      'transaction_id': 1,
      'code': 'code',
      'type': 'type',
      'mutation_type': 'mutationType',
      'amount': 'amount',
      'balance': 'balance',
      'transaction_date': 'transactionDate',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('mutation model', () {
    test(
      'from json',
      () {
        final result = MutationModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.status, equals(1));
        expect(result.customerId, equals(1));
        expect(result.walletId, equals(1));
        expect(result.transactionId, equals(1));
        expect(result.code, equals('code'));
        expect(result.type, equals('type'));
        expect(result.mutationType, equals('mutationType'));
        expect(result.amount, equals('amount'));
        expect(result.balance, equals('balance'));
        expect(result.transactionDate, equals('transactionDate'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = MutationModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('mutation model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<MutationModel>.fromJson(baseResp, MutationModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.status, equals(1));
        expect(result.data?.customerId, equals(1));
        expect(result.data?.walletId, equals(1));
        expect(result.data?.transactionId, equals(1));
        expect(result.data?.code, equals('code'));
        expect(result.data?.type, equals('type'));
        expect(result.data?.mutationType, equals('mutationType'));
        expect(result.data?.amount, equals('amount'));
        expect(result.data?.balance, equals('balance'));
        expect(result.data?.transactionDate, equals('transactionDate'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<MutationModel> fromJson =
            BaseResp.fromJson(baseResp, MutationModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
