import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/services/api_service.dart';
import 'package:lakuemas/cores/services/secure_storage_service.dart';
import 'package:lakuemas/features/profile/data/data_sources/Profile_remote_data_source.dart';
import 'package:lakuemas/features/profile/data/models/change_password_req.dart';
import 'package:lakuemas/features/profile/data/models/change_pin_req.dart';
import 'package:lakuemas/features/profile/data/models/update_address_req.dart';
import 'package:lakuemas/features/profile/data/models/update_user_data_req.dart';
import 'package:lakuemas/features/profile/domain/entities/update_address_entity.dart';
import 'package:mockito/mockito.dart';

import '../../../../cores/services/api_service_test.mocks.dart';

void main() {
  late MockHttpClientAdapter dioAdapterMock;
  late Dio dio;
  late ApiService apiService;
  late ProfileRemoteDataSource profileRemoteDataSource;

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
    profileRemoteDataSource = ProfileRemoteDataSource(apiService: apiService);
  });

  group(
    'Profile remote data source get user data',
    () {
      group('Success', () {
        setUp(() {
          responsepayload = jsonEncode({
            "code": 0,
            "msg_key": "SUCCESS",
            "message": "SUCCESS",
            "data": {
              "id": 0,
              "name": "string",
              "email": "string",
              "handphone": "string",
              "gender": "string",
              "place_of_birth": "string",
              "date_of_birth": "string",
              "marital_status": "string",
              "religion": "string",
              "occupation": "string",
              "income": "string",
              "purpose": "string",
              "avatar_url": "string",
              "pin_status": true,
              "is_elite": true,
              "customer_type_id": null,
              "customer_address": [
                {
                  "district_id": 0,
                  "address": "string",
                  "type": "home",
                  "postal_code": "string"
                }
              ],
              "customer_setting": {"with_price": true, "with_promo": true},
              "kyc_data": {
                "ktp": {
                  "number": "string",
                  "status": 0,
                  "image_url": "string",
                  "bank_id": null,
                },
                "npwp": {
                  "number": "string",
                  "status": 0,
                  "image_url": "string",
                  "bank_id": null,
                },
                "selfie": {
                  "number": "string",
                  "status": 0,
                  "image_url": "string",
                  "bank_id": null,
                },
                "account_number": {
                  "number": "string",
                  "status": 0,
                  "image_url": "string",
                  "bank_id": 0
                }
              }
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

            final result = await profileRemoteDataSource.getUserData(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
            );

            expect(result.code, equals(0));
            expect(result.msgKey, equals('SUCCESS'));
            expect(result.message, equals('SUCCESS'));
            var aaa = jsonDecode(responsepayload);
            expect(result.data?.toJson(), equals(aaa['data']));
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
              await profileRemoteDataSource.getUserData(
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
              await profileRemoteDataSource.getUserData(
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
              await profileRemoteDataSource.getUserData(
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
    'Profile remote data source update user data',
    () {
      late UpdateUserDataReq updateUserDataReq;
      setUp(
        () {
          updateUserDataReq = const UpdateUserDataReq(
            name: 'jhon doe',
            gender: 'laki-laki',
            placeOfBirth: 'jakarta',
            dateOfBirth: '01-12-1999',
            religion: 'islam',
            maritalStatus: 'belum menikah',
            income: 'income',
            occupation: 'occupation',
            purpose: 'purpose',
          );
        },
      );
      group('Success', () {
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

            final result = await profileRemoteDataSource.updateUserData(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              request: updateUserDataReq,
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
              await profileRemoteDataSource.updateUserData(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: updateUserDataReq,
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
              await profileRemoteDataSource.updateUserData(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: updateUserDataReq,
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
              await profileRemoteDataSource.updateUserData(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: updateUserDataReq,
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
    'Profile remote data source update address',
    () {
      late UpdateAddressReq updateAddressReq;
      setUp(
        () {
          updateAddressReq = UpdateAddressReq([
            UpdateAddressEntity(
              type: 'home',
              address: 'address1',
              districtId: 1,
              postalCode: '12345',
            ),
            UpdateAddressEntity(
              type: 'mailing',
              address: 'address2',
              districtId: 2,
              postalCode: '12349',
            ),
          ]);
        },
      );
      group('Success', () {
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

            final result = await profileRemoteDataSource.updateAddress(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              request: updateAddressReq,
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
              await profileRemoteDataSource.updateAddress(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: updateAddressReq,
              );
            } catch (e) {
              expect(e, isA<ClientException>());
              expect((e as ClientException).code, equals(400));
              expect((e).message, equals('The request parameter invalid'));
            }
          },
        );
      });

      group('Profile Failed UNPROCESSABLE-ENTITY', () {
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
              await profileRemoteDataSource.updateAddress(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: updateAddressReq,
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

      group('Profile Failed SERVER-ERROR', () {
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
              await profileRemoteDataSource.updateAddress(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: updateAddressReq,
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
    'Profile remote data source change password',
    () {
      late ChangePasswordReq changePasswordReq;
      setUp(
        () {
          changePasswordReq = const ChangePasswordReq(
            oldPassword: 'qwerty',
            newPassword: '123123',
            confirmPassword: '123123',
          );
        },
      );
      group('Success', () {
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

            final result = await profileRemoteDataSource.changePassword(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              request: changePasswordReq,
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
              await profileRemoteDataSource.changePassword(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: changePasswordReq,
              );
            } catch (e) {
              expect(e, isA<ClientException>());
              expect((e as ClientException).code, equals(400));
              expect((e).message, equals('The request parameter invalid'));
            }
          },
        );
      });

      group('Profile Failed UNPROCESSABLE-ENTITY', () {
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
              await profileRemoteDataSource.changePassword(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: changePasswordReq,
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

      group('Profile Failed SERVER-ERROR', () {
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
              await profileRemoteDataSource.changePassword(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: changePasswordReq,
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
    'Profile remote data source change pin',
    () {
      late ChangePinReq changePinReq;
      setUp(
        () {
          changePinReq = const ChangePinReq(
            oldPin: '123456',
            newPin: '123123',
            confirmPin: '123123',
          );
        },
      );
      group('Success', () {
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

            final result = await profileRemoteDataSource.changePin(
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              request: changePinReq,
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
              await profileRemoteDataSource.changePin(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: changePinReq,
              );
            } catch (e) {
              expect(e, isA<ClientException>());
              expect((e as ClientException).code, equals(400));
              expect((e).message, equals('The request parameter invalid'));
            }
          },
        );
      });

      group('Profile Failed UNPROCESSABLE-ENTITY', () {
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
              await profileRemoteDataSource.changePin(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: changePinReq,
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

      group('Profile Failed SERVER-ERROR', () {
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
              await profileRemoteDataSource.changePin(
                accessToken: 'accessToken',
                refreshToken: 'refreshToken',
                request: changePinReq,
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
