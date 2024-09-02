import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/_core/user/data/models/user_data_model.dart';
import 'package:lakuemas/features/profile/data/data_sources/interfaces/i_profile_local_data_source.dart';
import 'package:lakuemas/features/profile/data/data_sources/interfaces/i_profile_remote_data_source.dart';
import 'package:lakuemas/features/profile/data/models/change_password_req.dart';
import 'package:lakuemas/features/profile/data/models/change_pin_req.dart';
import 'package:lakuemas/features/profile/data/models/update_address_req.dart';
import 'package:lakuemas/features/profile/data/models/update_user_data_req.dart';
import 'package:lakuemas/features/profile/data/repositories/profile_repository.dart';
import 'package:lakuemas/features/profile/domain/entities/update_address_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource,
  IProfileRemoteDataSource,
  IProfileLocalDataSource,
])
void main() {
  late MockIProfileRemoteDataSource mockIProfileRemoteDataSource;
  late MockIProfileLocalDataSource mockIProfileLocalDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late ProfileRepository profileRepository;

  setUpAll(() {
    mockIProfileRemoteDataSource = MockIProfileRemoteDataSource();
    mockIProfileLocalDataSource = MockIProfileLocalDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    profileRepository = ProfileRepository(
      remoteDataSource: mockIProfileRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
      localDataSource: mockIProfileLocalDataSource,
    );
  });

  group(
    'Profile Repository',
    () {
      group('get user data', () {
        const String accessToken = 'accessToken';
        const String refreshToken = 'refreshToken';
        late Map<String, dynamic> data;
        setUp(
          () {
            data = {
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
              "customer_address": [
                {
                  "district_id": 0,
                  "address": "string",
                  "type": "home",
                  "postal_code": "string"
                }
              ],
              "customer_setting": {"with_price": true, "with_promo": true},
            };
          },
        );
        test(
          'success 200',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.getUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
            )).thenAnswer((realInvocation) async => BaseResp<UserDataModel>(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                  data: UserDataModel.fromJson(data),
                ));

            when(mockIProfileLocalDataSource
                    .saveUserData(UserDataModel.fromJson(data)))
                .thenAnswer((realInvocation) async => () {});
            when(mockIProfileLocalDataSource
                    .saveIsElite(data['is_elite'] ?? false))
                .thenAnswer((realInvocation) async => () {});

            final result = await profileRepository.getUserData();

            expect(result, Right(UserDataModel.fromJson(data)));
          },
        );

        test(
          'SessionException 401',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.getUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
            )).thenThrow(SessionException());

            final result = await profileRepository.getUserData();

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<SessionFailure>());
          },
        );

        test(
          'ClientException 400 or 422',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.getUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
            )).thenThrow(
                ClientException(400, 'The request parameter invalid', null));

            final result = await profileRepository.getUserData();

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<MobileValidationFailure>());
          },
        );

        test(
          'ServerException 500',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.getUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
            )).thenThrow(ServerException(false));

            when(mockIProfileLocalDataSource.getUserData())
                .thenAnswer((realInvocation) async => null);

            final result = await profileRepository.getUserData();

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<ServerFailure>());
          },
        );

        test(
          'UnknownException',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.getUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
            )).thenThrow(UnknownException('unknown'));

            final result = await profileRepository.getUserData();

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<UnknownFailure>());
          },
        );
      });

      group('update user data', () {
        const String accessToken = 'accessToken';
        const String refreshToken = 'refreshToken';
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
        test(
          'success 200',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateUserDataReq,
            )).thenAnswer((realInvocation) async => BaseResp(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                ));

            final result = await profileRepository.updateUserData(
              fullName: updateUserDataReq.name,
              gender: updateUserDataReq.gender,
              pob: updateUserDataReq.placeOfBirth,
              dob: updateUserDataReq.dateOfBirth,
              religion: updateUserDataReq.religion,
              income: updateUserDataReq.income,
              maritalStatus: updateUserDataReq.maritalStatus,
              occupation: updateUserDataReq.occupation,
              purpose: updateUserDataReq.purpose,
            );

            expect(result, const Right(true));
          },
        );

        test(
          'SessionException 401',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateUserDataReq,
            )).thenThrow(SessionException());

            final result = await profileRepository.updateUserData(
              fullName: updateUserDataReq.name,
              gender: updateUserDataReq.gender,
              pob: updateUserDataReq.placeOfBirth,
              dob: updateUserDataReq.dateOfBirth,
              religion: updateUserDataReq.religion,
              income: updateUserDataReq.income,
              maritalStatus: updateUserDataReq.maritalStatus,
              occupation: updateUserDataReq.occupation,
              purpose: updateUserDataReq.purpose,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<SessionFailure>());
          },
        );

        test(
          'ClientException 400 or 422',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateUserDataReq,
            )).thenThrow(
                ClientException(400, 'The request parameter invalid', null));

            final result = await profileRepository.updateUserData(
              fullName: updateUserDataReq.name,
              gender: updateUserDataReq.gender,
              pob: updateUserDataReq.placeOfBirth,
              dob: updateUserDataReq.dateOfBirth,
              religion: updateUserDataReq.religion,
              income: updateUserDataReq.income,
              maritalStatus: updateUserDataReq.maritalStatus,
              occupation: updateUserDataReq.occupation,
              purpose: updateUserDataReq.purpose,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<MobileValidationFailure>());
          },
        );

        test(
          'ServerException 500',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateUserDataReq,
            )).thenThrow(ServerException(false));

            final result = await profileRepository.updateUserData(
              fullName: updateUserDataReq.name,
              gender: updateUserDataReq.gender,
              pob: updateUserDataReq.placeOfBirth,
              dob: updateUserDataReq.dateOfBirth,
              religion: updateUserDataReq.religion,
              income: updateUserDataReq.income,
              maritalStatus: updateUserDataReq.maritalStatus,
              occupation: updateUserDataReq.occupation,
              purpose: updateUserDataReq.purpose,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<ServerFailure>());
          },
        );

        test(
          'UnknownException',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateUserData(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateUserDataReq,
            )).thenThrow(UnknownException('unknown'));

            final result = await profileRepository.updateUserData(
              fullName: updateUserDataReq.name,
              gender: updateUserDataReq.gender,
              pob: updateUserDataReq.placeOfBirth,
              dob: updateUserDataReq.dateOfBirth,
              religion: updateUserDataReq.religion,
              income: updateUserDataReq.income,
              maritalStatus: updateUserDataReq.maritalStatus,
              occupation: updateUserDataReq.occupation,
              purpose: updateUserDataReq.purpose,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<UnknownFailure>());
          },
        );
      });

      group('update address', () {
        const String accessToken = 'accessToken';
        const String refreshToken = 'refreshToken';
        late UpdateAddressReq updateAddressReq;
        setUp(
          () {
            updateAddressReq = UpdateAddressReq([
              UpdateAddressEntity(
                type: 'home',
                districtId: 1,
                address: 'address1',
                postalCode: '12345',
              ),
              UpdateAddressEntity(
                type: 'mailing',
                districtId: 2,
                address: 'address2',
                postalCode: '12349',
              ),
            ]);
          },
        );
        test(
          'success 200',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateAddress(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateAddressReq,
            )).thenAnswer((realInvocation) async => BaseResp(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                ));

            final result = await profileRepository.updateAddress(
              addressDatas: updateAddressReq.data,
            );

            expect(result, const Right(true));
          },
        );

        test(
          'SessionException 401',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateAddress(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateAddressReq,
            )).thenThrow(SessionException());

            final result = await profileRepository.updateAddress(
              addressDatas: updateAddressReq.data,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<SessionFailure>());
          },
        );

        test(
          'ClientException 400 or 422',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateAddress(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateAddressReq,
            )).thenThrow(
                ClientException(400, 'The request parameter invalid', null));

            final result = await profileRepository.updateAddress(
              addressDatas: updateAddressReq.data,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<MobileValidationFailure>());
          },
        );

        test(
          'ServerException 500',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateAddress(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateAddressReq,
            )).thenThrow(ServerException(false));

            final result = await profileRepository.updateAddress(
              addressDatas: updateAddressReq.data,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<ServerFailure>());
          },
        );

        test(
          'UnknownException',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.updateAddress(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: updateAddressReq,
            )).thenThrow(UnknownException('unknown'));

            final result = await profileRepository.updateAddress(
              addressDatas: updateAddressReq.data,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<UnknownFailure>());
          },
        );
      });

      group('change password', () {
        const String accessToken = 'accessToken';
        const String refreshToken = 'refreshToken';
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
        test(
          'success 200',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePassword(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePasswordReq,
            )).thenAnswer((realInvocation) async => BaseResp(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                ));

            final result = await profileRepository.changePassword(
              oldPassword: changePasswordReq.oldPassword,
              newPassword: changePasswordReq.newPassword,
              newPasswordConfirmation: changePasswordReq.confirmPassword,
            );

            expect(result, const Right(true));
          },
        );

        test(
          'SessionException 401',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePassword(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePasswordReq,
            )).thenThrow(SessionException());

            final result = await profileRepository.changePassword(
              oldPassword: changePasswordReq.oldPassword,
              newPassword: changePasswordReq.newPassword,
              newPasswordConfirmation: changePasswordReq.confirmPassword,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<SessionFailure>());
          },
        );

        test(
          'ClientException 400 or 422',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePassword(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePasswordReq,
            )).thenThrow(
                ClientException(400, 'The request parameter invalid', null));

            final result = await profileRepository.changePassword(
              oldPassword: changePasswordReq.oldPassword,
              newPassword: changePasswordReq.newPassword,
              newPasswordConfirmation: changePasswordReq.confirmPassword,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<MobileValidationFailure>());
          },
        );

        test(
          'ServerException 500',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePassword(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePasswordReq,
            )).thenThrow(ServerException(false));

            final result = await profileRepository.changePassword(
              oldPassword: changePasswordReq.oldPassword,
              newPassword: changePasswordReq.newPassword,
              newPasswordConfirmation: changePasswordReq.confirmPassword,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<ServerFailure>());
          },
        );

        test(
          'UnknownException',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePassword(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePasswordReq,
            )).thenThrow(UnknownException('unknown'));

            final result = await profileRepository.changePassword(
              oldPassword: changePasswordReq.oldPassword,
              newPassword: changePasswordReq.newPassword,
              newPasswordConfirmation: changePasswordReq.confirmPassword,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<UnknownFailure>());
          },
        );
      });

      group('change pin', () {
        const String accessToken = 'accessToken';
        const String refreshToken = 'refreshToken';
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
        test(
          'success 200',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePin(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePinReq,
            )).thenAnswer((realInvocation) async => BaseResp(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                ));

            final result = await profileRepository.changePin(
              oldPin: changePinReq.oldPin,
              newPin: changePinReq.newPin,
              newPinConfirmation: changePinReq.confirmPin,
            );

            expect(result, const Right(true));
          },
        );

        test(
          'SessionException 401',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePin(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePinReq,
            )).thenThrow(SessionException());

            final result = await profileRepository.changePin(
              oldPin: changePinReq.oldPin,
              newPin: changePinReq.newPin,
              newPinConfirmation: changePinReq.confirmPin,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<SessionFailure>());
          },
        );

        test(
          'ClientException 400 or 422',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePin(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePinReq,
            )).thenThrow(
                ClientException(400, 'The request parameter invalid', null));

            final result = await profileRepository.changePin(
              oldPin: changePinReq.oldPin,
              newPin: changePinReq.newPin,
              newPinConfirmation: changePinReq.confirmPin,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<MobileValidationFailure>());
          },
        );

        test(
          'ServerException 500',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePin(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePinReq,
            )).thenThrow(ServerException(false));

            final result = await profileRepository.changePin(
              oldPin: changePinReq.oldPin,
              newPin: changePinReq.newPin,
              newPinConfirmation: changePinReq.confirmPin,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<ServerFailure>());
          },
        );

        test(
          'UnknownException',
          () async {
            when(mockITokenLocalDataSource.getAccessToken())
                .thenAnswer((realInvocation) async => accessToken);
            when(mockITokenLocalDataSource.getRefreshToken())
                .thenAnswer((realInvocation) async => refreshToken);
            when(mockIProfileRemoteDataSource.changePin(
              accessToken: accessToken,
              refreshToken: refreshToken,
              request: changePinReq,
            )).thenThrow(UnknownException('unknown'));

            final result = await profileRepository.changePin(
              oldPin: changePinReq.oldPin,
              newPin: changePinReq.newPin,
              newPinConfirmation: changePinReq.confirmPin,
            );

            expect(result, isA<Left>());

            final result2 = result.fold((l) => l, (r) => r);
            expect(result2, isA<UnknownFailure>());
          },
        );
      });
    },
  );
}
