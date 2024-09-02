import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/laku_save/data/models/deposit_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'is_enable_update_extend': true,
      'account_number': '123456789',
      'interest': 'interest',
      'duration': 'duration',
      'duration_type': 'durationType',
      'extend_label': 'extendLabel',
      'start_date': 'startDate',
      'end_date': 'endDate',
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('deposit model', () {
    test(
      'from json',
      () {
        final result = DepositModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.isEnableUpdateExtend, equals(true));
        expect(result.accountNumber, equals('123456789'));
        expect(result.interest, equals('interest'));
        expect(result.duration, equals('duration'));
        expect(result.durationType, equals('durationType'));
        expect(result.extendLabel, equals('extendLabel'));
        expect(result.startDate, equals('startDate'));
        expect(result.endDate, equals('endDate'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = DepositModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('deposit model with base resp', () {
    test(
      'from json',
      () {
        final result =
            BaseResp<DepositModel>.fromJson(baseResp, DepositModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.isEnableUpdateExtend, equals(true));
        expect(result.data?.accountNumber, equals('123456789'));
        expect(result.data?.interest, equals('interest'));
        expect(result.data?.duration, equals('duration'));
        expect(result.data?.durationType, equals('durationType'));
        expect(result.data?.extendLabel, equals('extendLabel'));
        expect(result.data?.startDate, equals('startDate'));
        expect(result.data?.endDate, equals('endDate'));
      },
    );
    test(
      'to json',
      () {
        final BaseResp<DepositModel> fromJson =
            BaseResp.fromJson(baseResp, DepositModel.fromJson);
        final result = fromJson.data?.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
