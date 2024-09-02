import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:lakuemas/features/login/data/models/login_req.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_remote_data_source_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late LoginRemoteDataSource loginRemoteDataSource;
  late LoginReq loginReq;

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
    loginRemoteDataSource = LoginRemoteDataSource(apiService: apiService);
    loginReq = LoginReq(
      username: 'jhon.doe@email.com',
      password: 'password',
      firebaseToken: '-',
    );
  });

  group('Login Success', () {
    setUp(() {
      responsepayload = jsonEncode({
        "code": 0,
        "msg_key": "SUCCESS",
        "message": "SUCCESS",
        "data": {
          "email": loginReq.username,
          "phone_number": loginReq.username,
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
    test(
      '200',
      () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        final result = await loginRemoteDataSource.login(loginReq);

        expect(result.code, equals(0));
        expect(result.msgKey, equals('SUCCESS'));
        expect(result.message, equals('SUCCESS'));
        expect(result.data?.email, equals(loginReq.username));
        expect(result.data?.phoneNumber, equals(loginReq.username));
      },
    );
  });

  group('Login Failed Validation', () {
    setUp(() {
      responsepayload = jsonEncode({
        "code": 400,
        "message": "The request parameter invalid",
        "errors": {
          "email": "cannot be blank",
          "name": "cannot be blank",
          "password": "cannot be blank",
          "phone_number": "cannot be blank"
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
    test(
      '400',
      () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await loginRemoteDataSource.login(loginReq);
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(400));
          expect((e).message, equals('The request parameter invalid'));
        }
      },
    );
  });

  group('Login Failed UNPROCESSABLE-ENTITY', () {
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
    test(
      '422',
      () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await loginRemoteDataSource.login(loginReq);
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(422));
          expect(
              (e).message,
              equals(
                'Your request could not be processed, please check your request again',
              ));
        }
      },
    );
  });

  group('Login Failed SERVER-ERROR', () {
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
    test(
      '500',
      () async {
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);

        try {
          await loginRemoteDataSource.login(loginReq);
        } catch (e) {
          expect(e, isA<ServerException>());
        }
      },
    );
  });
}
