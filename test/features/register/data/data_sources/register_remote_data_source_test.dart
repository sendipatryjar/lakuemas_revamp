import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/register/data/data_source/register_remote_data_source.dart';
import 'package:lakuemas/features/register/data/models/register_req.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../cores/services/api_service_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late RegisterRemoteDataSource registerRemoteDataSource;
  late RegisterReq registerReq;

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
    registerRemoteDataSource = RegisterRemoteDataSource(apiService: apiService);
    registerReq = RegisterReq(
      name: 'Jhon Doe',
      phoneNumber: '08123456789',
      email: 'jhon.doe@email.com',
      password: 'password',
    );
  });

  group('Register Success', () {
    setUp(() {
      responsepayload = jsonEncode({
        "code": 200,
        "message": "SUCCESS",
        "data": {
          "id": 332,
          ...registerReq.toJson(),
          ...{
            "created_at": "2023-03-20T10:47:57.983+07:00",
            "updated_at": "2023-03-20T10:47:57.983+07:00",
            "deleted_at": null
          },
        },
        "msg_key": "SUCCESS"
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

        final result = await registerRemoteDataSource.register(registerReq);

        expect(result.code, equals(200));
        expect(result.msgKey, equals('SUCCESS'));
        expect(result.message, equals('SUCCESS'));
        expect(result.data?.name, equals(registerReq.name));
        expect(result.data?.phoneNumber, equals(registerReq.phoneNumber));
        expect(result.data?.email, equals(registerReq.email));
        expect(result.data?.createdAt, equals('2023-03-20T10:47:57.983+07:00'));
        expect(result.data?.updatedAt, equals('2023-03-20T10:47:57.983+07:00'));
      },
    );
  });

  group('Register Failed Validation', () {
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
          await registerRemoteDataSource.register(registerReq);
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(400));
          expect((e).message, equals('The request parameter invalid'));
        }
      },
    );
  });

  group('Register Failed UNPROCESSABLE-ENTITY', () {
    setUp(() {
      responsepayload = jsonEncode({
        "code": 422,
        "message": "phone number is already exist",
        "msg_key": "UNPROCESSABLE-ENTITY"
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
          await registerRemoteDataSource.register(registerReq);
        } catch (e) {
          expect(e, isA<ClientException>());
          expect((e as ClientException).code, equals(422));
          expect((e).message, equals('phone number is already exist'));
        }
      },
    );
  });
}
