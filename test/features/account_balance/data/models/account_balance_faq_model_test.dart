import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/models/base_list_resp.dart';
import 'package:lakuemas/features/account_balance/data/models/account_balance_faq_model.dart';

void main() {
  Map<String, dynamic> baseResp = {};
  Map<String, dynamic> resData = {};

  setUpAll(() {
    resData = {
      "question": "Apa itu Saldo Akun Lakuemas?",
      "answer":
          "Laku Simpan merupakan salah satu layanan Lakuemas dimana kamu mempercayakan emas kamu kepada Lakuemas dalam jangka waktu yang disepakati dengan mendapatkan imbal hasil berupa sewa modal tetap dalam wujud gramasi emas."
    };
    baseResp = {
      "code": 200,
      "msg_key": "SUCCESS",
      "message": "string",
      "data": [resData],
    };
  });

  group('account balance faq model', () {
    test(
      'from json',
      () {
        final result = AccountBalanceFaqModel.fromJson(resData);

        expect(result, isNotNull);
        expect(result.question, equals('Apa itu Saldo Akun Lakuemas?'));
        expect(
            result.answer,
            equals(
                'Laku Simpan merupakan salah satu layanan Lakuemas dimana kamu mempercayakan emas kamu kepada Lakuemas dalam jangka waktu yang disepakati dengan mendapatkan imbal hasil berupa sewa modal tetap dalam wujud gramasi emas.'));
      },
    );
    test(
      'to json',
      () {
        final fromJson = AccountBalanceFaqModel.fromJson(resData);
        final result = fromJson.toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });

  group('accounr balance faq model with base list resp', () {
    test(
      'from json',
      () {
        final result = BaseListResp<AccountBalanceFaqModel>.fromJson(
            baseResp, AccountBalanceFaqModel.fromJson);
        expect(result, isNotNull);
        expect(
            result.data?[0].question, equals('Apa itu Saldo Akun Lakuemas?'));
        expect(
            result.data?[0].answer,
            equals(
                'Laku Simpan merupakan salah satu layanan Lakuemas dimana kamu mempercayakan emas kamu kepada Lakuemas dalam jangka waktu yang disepakati dengan mendapatkan imbal hasil berupa sewa modal tetap dalam wujud gramasi emas.'));
      },
    );
    test(
      'to json',
      () {
        final BaseListResp<AccountBalanceFaqModel> fromJson =
            BaseListResp.fromJson(baseResp, AccountBalanceFaqModel.fromJson);
        final result = fromJson.data?[0].toJson();
        expect(result, isNotNull);
        expect(result, equals(resData));
      },
    );
  });
}
