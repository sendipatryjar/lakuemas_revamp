import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/transfer/data/data_sources/transfer_remote_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../../../cores/services/api_service_test.mocks.dart';

void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late TransferRemoteDataSource transferRemoteDataSource;

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
    transferRemoteDataSource = TransferRemoteDataSource(apiService: apiService);
  });

  group('transfer charge', () {
    setUp(() {
      responsepayload = jsonEncode({
        "code": 200,
        "msg_key": "SUCCESS",
        "message": "SUCCESS",
      });

      httpResponse = ResponseBody.fromString(
        responsepayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });

    const bool isAddFavorite = true;
    const double goldWeight = 10.0;
    const String accountNumber = '111111';

    test('success 200', () async {
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final result = await transferRemoteDataSource.transferCharge(
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      );
      expect(result.code, equals(200));
      expect(result.msgKey, equals('SUCCESS'));
      expect(result.message, equals('SUCCESS'));
    });
  });

  group('transfer charge', () {
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

    const bool isAddFavorite = true;
    const double goldWeight = 10.0;
    const String accountNumber = '111111';

    test('failure 400', () async {
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      try {
        await transferRemoteDataSource.transferCharge(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        );
      } catch (e) {
        expect(e, isA<ClientException>());
        expect((e as ClientException).code, equals(400));
        expect((e).message, equals('The request parameter invalid'));
      }
    });
  });

  group('transfer charge', () {
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

    const bool isAddFavorite = true;
    const double goldWeight = 10.0;
    const String accountNumber = '111111';

    test('failure 422', () async {
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      try {
        await transferRemoteDataSource.transferCharge(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
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

  group('transfer charge', () {
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

    const bool isAddFavorite = true;
    const double goldWeight = 10.0;
    const String accountNumber = '111111';

    test('failure 500', () async {
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      try {
        await transferRemoteDataSource.transferCharge(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
        );
      } catch (e) {
        expect(e, isA<ServerException>());
      }
    });
  });

  // Transfer Checkout
  group('transfer checkout', () {
    setUp(() {
      responsepayload = jsonEncode({
        "code": 200,
        "msg_key": "SUCCESS",
        "message": "SUCCESS",
      });

      httpResponse = ResponseBody.fromString(
        responsepayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    });

    const String trxKey = 'PRE111111111';

    test('success 200', () async {
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      final result = await transferRemoteDataSource.transferCheckout(
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
        transactionKey: trxKey,
      );
      expect(result.code, equals(200));
      expect(result.msgKey, equals('SUCCESS'));
      expect(result.message, equals('SUCCESS'));
    });
  });

  group('transfer checkout', () {
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

    const String trxKey = 'PRE111111111';

    test('failure 400', () async {
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      try {
        await transferRemoteDataSource.transferCheckout(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
          transactionKey: trxKey,
        );
      } catch (e) {
        expect(e, isA<ClientException>());
        expect((e as ClientException).code, equals(400));
        expect((e).message, equals('The request parameter invalid'));
      }
    });
  });

  group('transfer checkout', () {
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

    const String trxKey = 'PRE111111111';

    test('failure 422', () async {
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      try {
        await transferRemoteDataSource.transferCheckout(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
          transactionKey: trxKey,
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

  group('transfer checkout', () {
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

    const String trxKey = 'PRE111111111';

    test('failure 500', () async {
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);

      try {
        await transferRemoteDataSource.transferCheckout(
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
          transactionKey: trxKey,
        );
      } catch (e) {
        expect(e, isA<ServerException>());
      }
    });
  });
}
