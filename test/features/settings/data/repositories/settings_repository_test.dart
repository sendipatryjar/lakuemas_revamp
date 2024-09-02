import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/settings/data/data_sources/interfaces/i_settings_remote_data_source.dart';
import 'package:lakuemas/features/settings/data/models/update_settings_req.dart';
import 'package:lakuemas/features/settings/data/repositories/settings_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_repository_test.mocks.dart';

@GenerateMocks([
  ITokenLocalDataSource
], customMocks: [
  MockSpec<ISettingsRemoteDataSource>(
      onMissingStub: OnMissingStub.returnDefault)
])
void main() {
  late MockISettingsRemoteDataSource mockISettingsRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late SettingsRepository settingsRepository;

  setUpAll(() {
    mockISettingsRemoteDataSource = MockISettingsRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    settingsRepository = SettingsRepository(
      remoteDataSource: mockISettingsRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group('update settings', () {
    const String accessToken = 'accessToken';
    const String refreshToken = 'refreshToken';
    late UpdateSettingsReq updateSettingsReq;

    setUp(() {
      updateSettingsReq = const UpdateSettingsReq(
        withPrice: false,
        withPromo: false,
      );
    });

    test(
      'success 200',
      () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((realInvocation) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((realInvocation) async => refreshToken);
        when(mockISettingsRemoteDataSource.updateSettings(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: updateSettingsReq,
        )).thenAnswer((realInvocation) async => BaseResp(
              code: 200,
              msgKey: 'SUCCESS',
              message: 'SUCCESS',
            ));

        final result = await settingsRepository.updateSettings(
          updateSettingsReq: updateSettingsReq,
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
        when(mockISettingsRemoteDataSource.updateSettings(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: updateSettingsReq,
        )).thenThrow(SessionException());

        final result = await settingsRepository.updateSettings(
          updateSettingsReq: updateSettingsReq,
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
        when(mockISettingsRemoteDataSource.updateSettings(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: updateSettingsReq,
        )).thenThrow(
          ClientException(400, 'The request parameter invalid', null),
        );

        final result = await settingsRepository.updateSettings(
          updateSettingsReq: updateSettingsReq,
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
        when(mockISettingsRemoteDataSource.updateSettings(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: updateSettingsReq,
        )).thenThrow(ServerException(false));

        final result = await settingsRepository.updateSettings(
          updateSettingsReq: updateSettingsReq,
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
        when(mockISettingsRemoteDataSource.updateSettings(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: updateSettingsReq,
        )).thenThrow(UnknownException('unknown'));

        final result = await settingsRepository.updateSettings(
          updateSettingsReq: updateSettingsReq,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
