import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/laku_save/data/data_sources/lakusave_remote_data_source.dart';
import 'package:lakuemas/features/laku_save/data/models/get_transactions_req.dart';
import 'package:lakuemas/features/laku_save/data/models/gold_deposit_model.dart';
import 'package:lakuemas/features/laku_save/data/models/lakusave_checkout_req.dart';
import 'package:lakuemas/features/laku_save/data/models/transaction_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../cores/services/api_service_test.mocks.dart';

void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late LakusaveRemoteDataSource lakusaveRemoteDataSource;

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
    lakusaveRemoteDataSource = LakusaveRemoteDataSource(apiService: apiService);
  });

  group(
    'lakusave remote data source getMasterDataLakusave',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": {
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

            final result = await lakusaveRemoteDataSource.getMasterDataLakusave(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            var aaa = jsonDecode(responsepayload);
            expect(result.data, equals(GoldDepositModel.fromJson(aaa['data'])));
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
              await lakusaveRemoteDataSource.getMasterDataLakusave(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
              );
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
              await lakusaveRemoteDataSource.getMasterDataLakusave(
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
          },
        );
      });

      group('Failed SERVER-ERROR', () {
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
              await lakusaveRemoteDataSource.getMasterDataLakusave(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
              );
            } catch (e) {
              expect(e, isA<ServerException>());
            }
          },
        );
      });
    },
  );

  ///
  ///

  group(
    'lakusave remote data source checkout',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": [
              {
                "transaction_id": 1,
                "status": 3,
                "status_label": "Menunggu Disetujui",
                "transaction_code": "AD2100032",
                "gold_weight": "1",
                "interest": "3",
                "duration": "3",
                "duration_type": "daily",
                "extend_type": "Tidak diperpanjang",
                "start_date": "2023-07-06",
                "end_date": "2023-11-06"
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
        test(
          '200',
          () async {
            when(dioAdapterMock.fetch(any, any, any))
                .thenAnswer((_) async => httpResponse);

            final result = await lakusaveRemoteDataSource.checkout(
              request: LakusaveCheckoutReq(
                durationId: 1,
                extendedId: 1,
                goldWeight: 2.0,
                accountNumber: '123456789',
                accountNumberDest: '987654321',
              ),
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
            );

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
              await lakusaveRemoteDataSource.checkout(
                request: LakusaveCheckoutReq(
                  durationId: 1,
                  extendedId: 1,
                  goldWeight: 2.0,
                  accountNumber: '123456789',
                  accountNumberDest: '987654321',
                ),
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
              );
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
              await lakusaveRemoteDataSource.checkout(
                request: LakusaveCheckoutReq(
                  durationId: 1,
                  extendedId: 1,
                  goldWeight: 2.0,
                  accountNumber: '123456789',
                  accountNumberDest: '987654321',
                ),
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
          },
        );
      });

      group('Failed SERVER-ERROR', () {
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
              await lakusaveRemoteDataSource.checkout(
                request: LakusaveCheckoutReq(
                  durationId: 1,
                  extendedId: 1,
                  goldWeight: 2.0,
                  accountNumber: '123456789',
                  accountNumberDest: '987654321',
                ),
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
              );
            } catch (e) {
              expect(e, isA<ServerException>());
            }
          },
        );
      });
    },
  );

  // ///
  // ///

  group(
    'lakusave remote data source cancel',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": null,
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

            final result = await lakusaveRemoteDataSource.cancel(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              transactionCode: '123123',
            );

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
              await lakusaveRemoteDataSource.cancel(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                transactionCode: '123123',
              );
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
              await lakusaveRemoteDataSource.cancel(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                transactionCode: '123123',
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

      group('Failed SERVER-ERROR', () {
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
              await lakusaveRemoteDataSource.cancel(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                transactionCode: '123123',
              );
            } catch (e) {
              expect(e, isA<ServerException>());
            }
          },
        );
      });
    },
  );

  // ///
  // ///

  group(
    'lakusave remote data source getTransactions',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": [
              {
                'id': 1,
                'status': 1,
                'gold_weight': '5.0',
                'type_label': 'typeLabel',
                'status_label': 'statusLabel',
                'code': 'code',
                'created_at': 'createdAt',
                'updated_at': 'updatedAt',
                'deposit': {
                  'is_enable_update_extend': null,
                  'account_number': '123456789',
                  'interest': 'interest',
                  'duration': 'duration',
                  'duration_type': 'durationType',
                  'extend_label': 'extendLabel',
                  'start_date': 'startDate',
                  'end_date': 'endDate',
                },
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

            final result = await lakusaveRemoteDataSource.getTransactions(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              request: GetTransactionsReq(
                limit: 10,
                page: 1,
                type: 'type',
                status: 1,
                orderBy: 'DESC',
                sortBy: 'created_at',
              ),
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            var aaa = jsonDecode(responsepayload);
            expect(result.data,
                equals([TransactionModel.fromJson(aaa['data'][0])]));
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
              await lakusaveRemoteDataSource.getTransactions(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: GetTransactionsReq(
                  limit: 10,
                  page: 1,
                  type: 'type',
                  status: 1,
                  orderBy: 'DESC',
                  sortBy: 'created_at',
                ),
              );
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
              await lakusaveRemoteDataSource.getTransactions(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: GetTransactionsReq(
                  limit: 10,
                  page: 1,
                  type: 'type',
                  status: 1,
                  orderBy: 'DESC',
                  sortBy: 'created_at',
                ),
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

      group('Failed SERVER-ERROR', () {
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
              await lakusaveRemoteDataSource.getTransactions(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: GetTransactionsReq(
                  limit: 10,
                  page: 1,
                  type: 'type',
                  status: 1,
                  orderBy: 'DESC',
                  sortBy: 'created_at',
                ),
              );
            } catch (e) {
              expect(e, isA<ServerException>());
            }
          },
        );
      });
    },
  );

  // ///
  // ///

  group(
    'lakusave remote data source update extend',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": null,
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

            final result = await lakusaveRemoteDataSource.updateExtend(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              accountNumber: '123456789',
              extendId: 1,
            );

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
              await lakusaveRemoteDataSource.updateExtend(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                accountNumber: '123456789',
                extendId: 1,
              );
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
              await lakusaveRemoteDataSource.updateExtend(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                accountNumber: '123456789',
                extendId: 1,
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

      group('Failed SERVER-ERROR', () {
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
              await lakusaveRemoteDataSource.updateExtend(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                accountNumber: '123456789',
                extendId: 1,
              );
            } catch (e) {
              expect(e, isA<ServerException>());
            }
          },
        );
      });
    },
  );

  // ///
  // ///

  group(
    'lakusave remote data source get about',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = 'response get about';
          httpResponse = ResponseBody.fromString(
            responsepayload,
            200,
          );
        });
        test(
          '200',
          () async {
            when(dioAdapterMock.fetch(any, any, any))
                .thenAnswer((_) async => httpResponse);

            final result = await lakusaveRemoteDataSource.getAbout(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
            );

            expect(result, isNotNull);
            expect(result, isA<String>());
            expect(result, equals(responsepayload));
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
              await lakusaveRemoteDataSource.getAbout(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
              );
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
              await lakusaveRemoteDataSource.getAbout(
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
          },
        );
      });

      group('Failed SERVER-ERROR', () {
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
              await lakusaveRemoteDataSource.getAbout(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
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
