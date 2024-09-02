import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/_core/transaction/data/models/price_model.dart';
import 'package:lakuemas/features/account_balance/data/data_sources/account_balance_remote_data_source.dart';
import 'package:lakuemas/features/account_balance/data/models/account_balance_faq_model.dart';
import 'package:lakuemas/features/account_balance/data/models/bank_me_model.dart';
import 'package:lakuemas/features/account_balance/data/models/mutation_model.dart';
import 'package:lakuemas/features/account_balance/data/models/withdrawal_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../cores/services/api_service_test.mocks.dart';

void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late AccountBalanceRemoteDataSource accountBalanceRemoteDataSource;

  late String responsepayload;
  late ResponseBody httpResponse;

  setUpAll(() {
    dioAdapterMock = MockHttpClientAdapter();
    dio = Dio();
    dio.httpClientAdapter = dioAdapterMock;
    apiService = ApiService(
      dio: dio,
      tokenDio: Dio(),
      secureStorageService: SecureStorageService(),
      isForTest: true,
    );
    accountBalanceRemoteDataSource =
        AccountBalanceRemoteDataSource(apiService: apiService);
  });

  group('account balance getMutations', () {
    group('[success]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 200,
          "msg_key": "SUCCESS",
          "message": "SUCCESS",
          "data": [
            {
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
            }
          ],
        });

        httpResponse = ResponseBody.fromString(
          responsepayload,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('success 200', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await accountBalanceRemoteDataSource.getMutations(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
          status: 1,
          period: 'period',
          startDate: 'startDate',
          endDate: 'endDate',
        );
        expect(result.code, equals(200));
        expect(result.msgKey, equals('SUCCESS'));
        expect(result.message, equals('SUCCESS'));
        var aaa = jsonDecode(responsepayload);
        expect(result.data, equals([MutationModel.fromJson(aaa['data'][0])]));
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 400,
          "message": "The request parameter invalid",
          "errors": {
            "field": "cannot be blank",
          },
          "msg_key": "VALIDATION-ERROR"
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          400,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 400', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getMutations(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(400));
          expect((e).message, equals('The request parameter invalid'));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 422,
          "msg_key": "UNPROCESSABLE-ENTITY",
          "message":
              "Your request could not be processed, please check your request again",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          422,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 422', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getMutations(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(422));
          expect(
              (e).message,
              equals(
                'Your request could not be processed, please check your request again',
              ));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 500,
          "msg_key": "ERROR",
          "message": "Something went wrong",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          500,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 500', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getMutations(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
            status: 1,
            period: 'period',
            startDate: 'startDate',
            endDate: 'endDate',
          );
        } catch (e) {
          expect(e, isA<ServerException>());
        }
      });
    });
  });

  // account balance getFaq
  group('account balance getFaq', () {
    group('[success]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 200,
          "msg_key": "SUCCESS",
          "message": "SUCCESS",
          "data": [
            {
              'question': 'question',
              'answer': 'answer',
            }
          ],
        });

        httpResponse = ResponseBody.fromString(
          responsepayload,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('success 200', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await accountBalanceRemoteDataSource.getFaq(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
        );
        expect(result.code, equals(200));
        expect(result.msgKey, equals('SUCCESS'));
        expect(result.message, equals('SUCCESS'));
        var aaa = jsonDecode(responsepayload);
        expect(result.data,
            equals([AccountBalanceFaqModel.fromJson(aaa['data'][0])]));
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 400,
          "message": "The request parameter invalid",
          "errors": {
            "field": "cannot be blank",
          },
          "msg_key": "VALIDATION-ERROR"
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          400,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 400', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getFaq(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(400));
          expect((e).message, equals('The request parameter invalid'));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 422,
          "msg_key": "UNPROCESSABLE-ENTITY",
          "message":
              "Your request could not be processed, please check your request again",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          422,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 422', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getFaq(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(422));
          expect(
              (e).message,
              equals(
                'Your request could not be processed, please check your request again',
              ));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 500,
          "msg_key": "ERROR",
          "message": "Something went wrong",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          500,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 500', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getFaq(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ServerException>());
        }
      });
    });
  });

  // account balance getPrice
  group('account balance getPrice', () {
    group('[success]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 200,
          "msg_key": "SUCCESS",
          "message": "SUCCESS",
          "data": {
            "price": "990000",
            "selling_price": "990000",
            "elite_selling_price": "990000",
            "purchase_price": "990000",
            "elite_purchase_price": "990000",
            "tax_percentage": "3",
            "tax_nominal": "3000",
            "minimum_nominal": "50000",
            "minimum_grammation": "0.0506",
            "placeholder_nominal": ["100000", "200000", "300000"],
            "placeholder_grammation": ["1.00", "2.00", "3.00"]
          },
        });

        httpResponse = ResponseBody.fromString(
          responsepayload,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('success 200', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await accountBalanceRemoteDataSource.getPrice(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
        );
        expect(result.code, equals(200));
        expect(result.msgKey, equals('SUCCESS'));
        expect(result.message, equals('SUCCESS'));
        var aaa = jsonDecode(responsepayload);
        expect(result.data, equals(PriceModel.fromJson(aaa['data'])));
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 400,
          "message": "The request parameter invalid",
          "errors": {
            "field": "cannot be blank",
          },
          "msg_key": "VALIDATION-ERROR"
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          400,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 400', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getPrice(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(400));
          expect((e).message, equals('The request parameter invalid'));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 422,
          "msg_key": "UNPROCESSABLE-ENTITY",
          "message":
              "Your request could not be processed, please check your request again",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          422,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 422', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getPrice(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(422));
          expect(
              (e).message,
              equals(
                'Your request could not be processed, please check your request again',
              ));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 500,
          "msg_key": "ERROR",
          "message": "Something went wrong",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          500,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 500', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getPrice(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ServerException>());
        }
      });
    });
  });

  // account balance getBankMe
  group('account balance getBankMe', () {
    group('[success]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 200,
          "msg_key": "SUCCESS",
          "message": "SUCCESS",
          "data": {
            'id': 1,
            'customer_id': 1,
            'name': 'name',
            'account_name': 'accountName',
            'account_number': 'accountNumber',
            'logo': 'logo',
            'service_fee': 'serviceFee',
          }
        });

        httpResponse = ResponseBody.fromString(
          responsepayload,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('success 200', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await accountBalanceRemoteDataSource.getBankMe(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
        );
        expect(result.code, equals(200));
        expect(result.msgKey, equals('SUCCESS'));
        expect(result.message, equals('SUCCESS'));
        var aaa = jsonDecode(responsepayload);
        expect(result.data, equals(BankMeModel.fromJson(aaa['data'])));
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 400,
          "message": "The request parameter invalid",
          "errors": {
            "field": "cannot be blank",
          },
          "msg_key": "VALIDATION-ERROR"
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          400,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 400', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getBankMe(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(400));
          expect((e).message, equals('The request parameter invalid'));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 422,
          "msg_key": "UNPROCESSABLE-ENTITY",
          "message":
              "Your request could not be processed, please check your request again",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          422,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 422', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getBankMe(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(422));
          expect(
              (e).message,
              equals(
                'Your request could not be processed, please check your request again',
              ));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 500,
          "msg_key": "ERROR",
          "message": "Something went wrong",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          500,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 500', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.getBankMe(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
          );
        } catch (e) {
          expect(e, isA<ServerException>());
        }
      });
    });
  });

  // account balance withdraw
  group('account balance withdraw', () {
    group('[success]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 200,
          "msg_key": "SUCCESS",
          "message": "SUCCESS",
          "data": {
            'transaction_id': 1,
            'status': 1,
            'amount': 'amount',
            'gross_amount': 'grossAmount',
            'service_fee': 'serviceFee',
            'transaction_code': 'transactionCode',
          }
        });

        httpResponse = ResponseBody.fromString(
          responsepayload,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('success 200', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await accountBalanceRemoteDataSource.withdraw(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
          amount: 10,
        );
        expect(result.code, equals(200));
        expect(result.msgKey, equals('SUCCESS'));
        expect(result.message, equals('SUCCESS'));
        var aaa = jsonDecode(responsepayload);
        expect(result.data, equals(WithdrawalModel.fromJson(aaa['data'])));
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 400,
          "message": "The request parameter invalid",
          "errors": {
            "field": "cannot be blank",
          },
          "msg_key": "VALIDATION-ERROR"
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          400,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 400', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.withdraw(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
            amount: 10,
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(400));
          expect((e).message, equals('The request parameter invalid'));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 422,
          "msg_key": "UNPROCESSABLE-ENTITY",
          "message":
              "Your request could not be processed, please check your request again",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          422,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 422', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.withdraw(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
            amount: 10,
          );
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(422));
          expect(
              (e).message,
              equals(
                'Your request could not be processed, please check your request again',
              ));
        }
      });
    });

    group('[failure]', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 500,
          "msg_key": "ERROR",
          "message": "Something went wrong",
        });
        httpResponse = ResponseBody.fromString(
          responsepayload,
          500,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      test('failure 500', () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await accountBalanceRemoteDataSource.withdraw(
            accessToken: 'accessToken',
            refreshToken: 'refreshToken',
            amount: 10,
          );
        } catch (e) {
          expect(e, isA<ServerException>());
        }
      });
    });
  });
}
