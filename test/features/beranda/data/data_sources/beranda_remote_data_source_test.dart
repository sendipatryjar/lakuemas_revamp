import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/_core/transaction/data/models/price_model.dart';
import 'package:lakuemas/features/_core/user/data/models/balance_model.dart';
import 'package:lakuemas/features/article/data/models/article_model.dart';
import 'package:lakuemas/features/beranda/data/data_sources/beranda_remote_data_source.dart';
import 'package:lakuemas/features/beranda/data/models/menu_model.dart';
import 'package:lakuemas/features/beranda/data/models/promo_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../cores/services/api_service_test.mocks.dart';

void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late BerandaRemoteDataSource berandaRemoteDataSource;

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
    berandaRemoteDataSource = BerandaRemoteDataSource(apiService: apiService);
  });

  group(
    'beranda remote data source getBalances',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": [
              {
                'customer_id': 1,
                'payment_method_id': 12,
                'transaction_status': 1,
                'nominal_balance': 20000,
                'grammation_balance': 'grammation_balance',
                'account_number': 'account_number',
                'transaction_code': 'transaction_code',
                'type': 'type',
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

            final result = await berandaRemoteDataSource.getBalances(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            var aaa = jsonDecode(responsepayload);
            expect(
                result.data, equals([BalanceModel.fromJson(aaa['data'][0])]));
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
              await berandaRemoteDataSource.getBalances(
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
              await berandaRemoteDataSource.getBalances(
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
              await berandaRemoteDataSource.getBalances(
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

  group(
    'beranda remote data source getMenus',
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
                'name': 'name',
                'description': 'description',
                'parent_id': 1,
                'position': 1,
                'is_active': 1,
                'created_at': 'createdAt',
                'updated_at': 'updatedAt',
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

            final result = await berandaRemoteDataSource.getMenus(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            var aaa = jsonDecode(responsepayload);
            expect(result.data, equals([MenuModel.fromJson(aaa['data'][0])]));
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
              await berandaRemoteDataSource.getMenus(
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
              await berandaRemoteDataSource.getMenus(
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
              await berandaRemoteDataSource.getMenus(
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

  group(
    'beranda remote data source getArticles',
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
                'title': 'title',
                'page_title': 'pageTitle',
                'permalink': 'permalink',
                'sm_text': 'smText',
                'mid_text': 'midText',
                'content': 'content',
                'image': 'image',
                'created_at': 'createdAt',
                'updated_at': 'updatedAt',
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

            final result = await berandaRemoteDataSource.getArticles(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              limit: '10',
              page: '1',
              orderBy: 'created_at',
              sortBy: 'desc',
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            var aaa = jsonDecode(responsepayload);
            expect(
                result.data, equals([ArticleModel.fromJson(aaa['data'][0])]));
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
              await berandaRemoteDataSource.getArticles(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                limit: '10',
                page: '1',
                orderBy: 'created_at',
                sortBy: 'desc',
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
              await berandaRemoteDataSource.getArticles(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                limit: '10',
                page: '1',
                orderBy: 'created_at',
                sortBy: 'desc',
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
              await berandaRemoteDataSource.getArticles(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                limit: '10',
                page: '1',
                orderBy: 'created_at',
                sortBy: 'desc',
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
    'buy gold remote data source getPriceSetting',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
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
        test(
          '200',
          () async {
            when(dioAdapterMock.fetch(any, any, any))
                .thenAnswer((_) async => httpResponse);

            final result = await berandaRemoteDataSource.getPriceSetting(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            var aaa = jsonDecode(responsepayload);
            expect(result.data, equals(PriceModel.fromJson(aaa['data'])));
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
              await berandaRemoteDataSource.getPriceSetting(
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
              await berandaRemoteDataSource.getPriceSetting(
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
              await berandaRemoteDataSource.getPriceSetting(
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
    'beranda remote data source getPromos',
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
                'title': 'title',
                'content': 'content',
                'image': 'imageUrl',
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

            final result = await berandaRemoteDataSource.getPromos(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              limit: 10,
              page: 1,
              orderBy: 'created_at',
              sortBy: 'desc',
              keyword: 'keyword',
              isActive: 1,
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            var aaa = jsonDecode(responsepayload);
            expect(result.data, equals([PromoModel.fromJson(aaa['data'][0])]));
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
              await berandaRemoteDataSource.getPromos(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                limit: 10,
                page: 1,
                orderBy: 'created_at',
                sortBy: 'desc',
                keyword: 'keyword',
                isActive: 1,
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
              await berandaRemoteDataSource.getPromos(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                limit: 10,
                page: 1,
                orderBy: 'created_at',
                sortBy: 'desc',
                keyword: 'keyword',
                isActive: 1,
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
              await berandaRemoteDataSource.getPromos(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                limit: 10,
                page: 1,
                orderBy: 'created_at',
                sortBy: 'desc',
                keyword: 'keyword',
                isActive: 1,
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
