import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/profile/data/data_sources/address_remote_data_source.dart';
import 'package:lakuemas/features/profile/data/models/address_req.dart';
import 'package:mockito/mockito.dart';

import '../../../../cores/services/api_service_test.mocks.dart';

void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late AddressRemoteDataSource addressRemoteDataSource;
  late AddressReq addressReq;

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
    addressRemoteDataSource = AddressRemoteDataSource(apiService: apiService);
  });

  group(
    'address remote data source get province',
    () {
      setUp(
        () {
          addressReq = const AddressReq(
            limit: 10,
            page: 1,
            orderBy: 'name',
            sortBy: 'name',
          );
        },
      );
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": [
              {
                "id": 0,
                "name": "string",
                "created_at": "2019-08-24T14:15:22Z",
                "updated_at": "2019-08-24T14:15:22Z"
              },
              {
                "id": 1,
                "name": "string2",
                "created_at": "2019-08-24T14:15:22Z",
                "updated_at": "2019-08-24T14:15:22Z"
              },
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
        test(
          '200',
          () async {
            when(dioAdapterMock.fetch(any, any, any))
                .thenAnswer((_) async => httpResponse);

            final result = await addressRemoteDataSource.getProvinces(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              request: addressReq,
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            expect(result.data, isNotEmpty);
            expect(result.data?.length, equals(2));
          },
        );
      });

      group('Failed Validation', () {
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
              await addressRemoteDataSource.getProvinces(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
              );
            } catch (e) {
              expect(e, isA<ClientException>());
              expect((e as ClientException).code, equals(400));
              expect((e).message, equals('The request parameter invalid'));
            }
          },
        );
      });

      group('Address Failed UNPROCESSABLE-ENTITY', () {
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
              await addressRemoteDataSource.getProvinces(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
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
          },
        );
      });

      group('Address Failed SERVER-ERROR', () {
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
              await addressRemoteDataSource.getProvinces(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
              );
            } catch (e) {
              expect(e, isA<ServerException>());
            }
          },
        );
      });
    },
  );

  group(
    'address remote data source get cities',
    () {
      setUp(
        () {
          addressReq = const AddressReq(
            provinceId: 1,
            limit: 10,
            page: 1,
            orderBy: 'name',
            sortBy: 'name',
          );
        },
      );
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": [
              {
                "id": 0,
                "city": "string",
                "province_id": 1,
                "created_at": "2019-08-24T14:15:22Z",
                "updated_at": "2019-08-24T14:15:22Z"
              },
              {
                "id": 1,
                "city": "string2",
                "province_id": 1,
                "created_at": "2019-08-24T14:15:22Z",
                "updated_at": "2019-08-24T14:15:22Z"
              },
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
        test(
          '200',
          () async {
            when(dioAdapterMock.fetch(any, any, any))
                .thenAnswer((_) async => httpResponse);

            final result = await addressRemoteDataSource.getCities(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              request: addressReq,
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            expect(result.data, isNotEmpty);
            expect(result.data?.length, equals(2));
          },
        );
      });

      group('Failed Validation', () {
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
              await addressRemoteDataSource.getCities(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
              );
            } catch (e) {
              expect(e, isA<ClientException>());
              expect((e as ClientException).code, equals(400));
              expect((e).message, equals('The request parameter invalid'));
            }
          },
        );
      });

      group('Address Failed UNPROCESSABLE-ENTITY', () {
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
              await addressRemoteDataSource.getCities(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
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
          },
        );
      });

      group('Address Failed SERVER-ERROR', () {
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
              await addressRemoteDataSource.getCities(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
              );
            } catch (e) {
              expect(e, isA<ServerException>());
            }
          },
        );
      });
    },
  );

  group(
    'address remote data source get districts',
    () {
      setUp(
        () {
          addressReq = const AddressReq(
            cityId: 1,
            limit: 10,
            page: 1,
            orderBy: 'name',
            sortBy: 'name',
          );
        },
      );
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": [
              {
                "id": 0,
                "name": "string",
                "city_id": 1,
                "created_at": "2019-08-24T14:15:22Z",
                "updated_at": "2019-08-24T14:15:22Z"
              },
              {
                "id": 1,
                "name": "string2",
                "province_id": 1,
                "created_at": "2019-08-24T14:15:22Z",
                "updated_at": "2019-08-24T14:15:22Z"
              },
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
        test(
          '200',
          () async {
            when(dioAdapterMock.fetch(any, any, any))
                .thenAnswer((_) async => httpResponse);

            final result = await addressRemoteDataSource.getDistricts(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              request: addressReq,
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            expect(result.data, isNotEmpty);
            expect(result.data?.length, equals(2));
          },
        );
      });

      group('Failed Validation', () {
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
              await addressRemoteDataSource.getDistricts(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
              );
            } catch (e) {
              expect(e, isA<ClientException>());
              expect((e as ClientException).code, equals(400));
              expect((e).message, equals('The request parameter invalid'));
            }
          },
        );
      });

      group('Address Failed UNPROCESSABLE-ENTITY', () {
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
              await addressRemoteDataSource.getDistricts(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
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
          },
        );
      });

      group('Address Failed SERVER-ERROR', () {
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
              await addressRemoteDataSource.getDistricts(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: addressReq,
              );
            } catch (e) {
              expect(e, isA<ServerException>());
            }
          },
        );
      });
    },
  );
}
