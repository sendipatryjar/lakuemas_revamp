import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/laku_save/data/models/gold_deposit_model.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_duration_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_extend_entity.dart';
import 'package:lakuemas/features/laku_save/domain/entities/lakusave_interest_entity.dart';
import 'package:lakuemas/features/_core/others/domain/entities/terms_and_conditions_entity.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      'minimum_balance': '10',
      'elite_minimum_balance': '1',
      'term_and_conditions': {
        'title': 'title',
        'description': 'description',
      },
      'durations': [
        {
          'id': 1,
          'type': 'type',
          'duration': 4,
        },
      ],
      'extends': [
        {
          'id': 1,
          'name': 'name',
          'description': 'description',
        },
      ],
      'interests': [
        {
          'id': 1,
          'deposit_duraton_id': 1,
          'customer_type_id': 1,
          'interest': 3.0,
          'tax': 0.0,
          'minimum_balance': 10.0,
          'elite_minimum_balance': 1.0,
          'maximum_balance': 100.0,
          'created_at': 'createdAt',
          'updated_at': 'updatedAt',
        },
      ],
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": resData,
    };
  });

  group('gold deposit model', () {
    test(
      'from json',
      () {
        final result = GoldDepositModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.minimumBalance, equals('10'));
        expect(result.eliteMinimumBalance, equals('1'));
        expect(
            result.termsAndConditionsEntity, isA<TermsAndConditionsEntity>());
        expect(result.durations, isA<List<LakusaveDurationEntity>>());
        expect(result.extendss, isA<List<LakusaveExtendEntity>>());
        expect(result.interests, isA<List<LakusaveInterestEntity>>());
      },
    );
  });

  group('gold deposit model with base resp', () {
    test(
      'from json',
      () {
        final result = BaseResp<GoldDepositModel>.fromJson(
            baseResp, GoldDepositModel.fromJson);
        expect(result, isNotNull);
        expect(result.data?.minimumBalance, equals('10'));
        expect(result.data?.eliteMinimumBalance, equals('1'));
        expect(result.data?.termsAndConditionsEntity,
            isA<TermsAndConditionsEntity>());
        expect(result.data?.durations, isA<List<LakusaveDurationEntity>>());
        expect(result.data?.extendss, isA<List<LakusaveExtendEntity>>());
        expect(result.data?.interests, isA<List<LakusaveInterestEntity>>());
      },
    );
  });
}
