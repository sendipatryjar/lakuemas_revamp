import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/otp/data/data_sources/otp_remote_data_source.dart';
import 'package:lakuemas/features/otp/data/models/send_otp_req.dart';
import 'package:lakuemas/features/otp/data/models/verify_otp_req.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'otp_remote_data_source_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late OtpRemoteDataSource otpRemoteDataSource;
  late SendOtpReq sendOtpReq;
  late VerifyOtpReq verifyOtpReq;

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
    otpRemoteDataSource = OtpRemoteDataSource(apiService: apiService);
    sendOtpReq = SendOtpReq(username: '0812345678', otpType: 1);
    verifyOtpReq =
        VerifyOtpReq(username: '0812345678', otpCode: '123456', otpType: 1);
  });

  group('Otp Remote Data Source send otp', () {
    group('success', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 0,
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
      test(
        '200',
        () async {
          when(dioAdapterMock.fetch(any, any, any))
              .thenAnswer((_) async => httpResponse);

          final result = await otpRemoteDataSource.sendOtpRegister(sendOtpReq);

          expect(result.code, equals(0));
          expect(result.msgKey, equals('SUCCESS'));
          expect(result.message, equals('SUCCESS'));
        },
      );
    });

    group('Failed Validation', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 400,
          "msg_key": "VALIDATION-ERROR",
          "message": "The request parameter invalid",
          "errors": {},
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
            await otpRemoteDataSource.sendOtpRegister(sendOtpReq);
          } catch (e) {
            expect(e, isA<ClientException>());
            expect((e as ClientException).code, equals(400));
            expect((e).message, equals('The request parameter invalid'));
          }
        },
      );
    });

    group('Failed UNPROCESSABLE-ENTITY', () {
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
            await otpRemoteDataSource.sendOtpRegister(sendOtpReq);
          } catch (e) {
            expect(e, isA<ClientException>());
            expect((e as ClientException).code, equals(422));
            expect((e).message, equals('phone number is already exist'));
          }
        },
      );
    });

    group('Failed Server Error', () {
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
            await otpRemoteDataSource.sendOtpRegister(sendOtpReq);
          } catch (e) {
            expect(e, isA<ServerException>());
          }
        },
      );
    });
  });

  //!
  group('Otp Remote Data Source verify otp', () {
    group('success', () {
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
      test(
        '200',
        () async {
          when(dioAdapterMock.fetch(any, any, any))
              .thenAnswer((_) async => httpResponse);

          final result =
              await otpRemoteDataSource.verifyOtpRegister(verifyOtpReq);

          expect(result.code, equals(200));
          expect(result.msgKey, equals('SUCCESS'));
          expect(result.message, equals('SUCCESS'));
        },
      );
    });

    group('Failed Validation', () {
      setUp(() {
        responsepayload = jsonEncode({
          "code": 400,
          "msg_key": "VALIDATION-ERROR",
          "message": "The request parameter invalid",
          "errors": {},
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
            await otpRemoteDataSource.verifyOtpRegister(verifyOtpReq);
          } catch (e) {
            expect(e, isA<ClientException>());
            expect((e as ClientException).code, equals(400));
            expect((e).message, equals('The request parameter invalid'));
          }
        },
      );
    });

    group('Failed UNPROCESSABLE-ENTITY', () {
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
            await otpRemoteDataSource.verifyOtpRegister(verifyOtpReq);
          } catch (e) {
            expect(e, isA<ClientException>());
            expect((e as ClientException).code, equals(422));
            expect((e).message, equals('phone number is already exist'));
          }
        },
      );
    });

    group('Failed Server Error', () {
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
            await otpRemoteDataSource.verifyOtpRegister(verifyOtpReq);
          } catch (e) {
            expect(e, isA<ServerException>());
          }
        },
      );
    });
  });
}
