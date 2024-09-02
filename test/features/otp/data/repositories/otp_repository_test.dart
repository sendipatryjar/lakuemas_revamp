import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/otp/data/data_sources/interfaces/i_otp_remote_data_source.dart';
import 'package:lakuemas/features/otp/data/models/verify_otp_login_model.dart';
import 'package:lakuemas/features/otp/data/models/verify_otp_register_model.dart';
import 'package:lakuemas/features/otp/data/repositories/otp_reposotry.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'otp_repository_test.mocks.dart';

@GenerateMocks([IOtpRemoteDataSource, ITokenLocalDataSource])
void main() {
  const String accessToken = 'accessToken';
  const String refreshToken = 'refreshToken';
  late MockIOtpRemoteDataSource mockIOtpRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late OtpRepository otpRepository;

  setUpAll(() {
    mockIOtpRemoteDataSource = MockIOtpRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    otpRepository = OtpRepository(
      remoteDataSource: mockIOtpRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  group('Otp Repository send otp', () {
    test(
      'Success 200',
      () async {
        when(mockIOtpRemoteDataSource.sendOtpRegister(any))
            .thenAnswer((realInvocation) async => BaseResp<dynamic>(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                  data: {
                    'username': 'jhon.doe@email.com',
                    'otp_type': 0,
                  },
                ));

        final result = await otpRepository.sendOtp(
          username: 'jhon.doe@email.com',
          otpType: 0,
        );

        expect(result, const Right(true));
      },
    );

    test(
      'SessionException 401',
      () async {
        when(mockIOtpRemoteDataSource.sendOtpRegister(any))
            .thenThrow(SessionException());

        final result = await otpRepository.sendOtp(
          username: 'jhon.doe@email.com',
          otpType: 0,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientException 400 or 422',
      () async {
        when(mockIOtpRemoteDataSource.sendOtpRegister(any)).thenThrow(
            ClientException(400, 'The request parameter invalid', null));

        final result = await otpRepository.sendOtp(
          username: 'jhon.doe@email.com',
          otpType: 0,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerException 500',
      () async {
        when(mockIOtpRemoteDataSource.sendOtpRegister(any))
            .thenThrow(ServerException(false));

        final result = await otpRepository.sendOtp(
          username: 'jhon.doe@email.com',
          otpType: 0,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownException',
      () async {
        when(mockIOtpRemoteDataSource.sendOtpRegister(any))
            .thenThrow(UnknownException('unknown'));

        final result = await otpRepository.sendOtp(
          username: 'jhon.doe@email.com',
          otpType: 0,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });

  //!
  group('Otp Repository verify otp', () {
    test(
      'Register Success 200',
      () async {
        when(mockIOtpRemoteDataSource.verifyOtpRegister(any)).thenAnswer(
            (realInvocation) async => BaseResp<VerifyOtpRegisterModel>(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                ));

        final result = await otpRepository.verifyOtp(
          username: 'jhon.doe@email.com',
          otpCode: '123456',
          otpLocation: 1,
        );

        expect(result, const Right(null));
      },
    );

    test(
      'Login Success 200',
      () async {
        when(mockITokenLocalDataSource.getAccessToken())
            .thenAnswer((realInvocation) async => accessToken);
        when(mockITokenLocalDataSource.getRefreshToken())
            .thenAnswer((realInvocation) async => refreshToken);
        when(mockIOtpRemoteDataSource.verifyOtpLogin(any))
            .thenAnswer((realInvocation) async => BaseResp<VerifyOtpLoginModel>(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                ));

        final result = await otpRepository.verifyOtp(
          username: 'jhon.doe@email.com',
          otpCode: '123456',
          otpLocation: 0,
        );

        expect(result, const Right(null));
      },
    );

    test(
      'SessionException 401',
      () async {
        when(mockIOtpRemoteDataSource.verifyOtpRegister(any))
            .thenThrow(SessionException());

        final result = await otpRepository.verifyOtp(
          username: 'jhon.doe@email.com',
          otpCode: '123456',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientException 400 or 422',
      () async {
        when(mockIOtpRemoteDataSource.verifyOtpRegister(any)).thenThrow(
            ClientException(400, 'The request parameter invalid', null));

        final result = await otpRepository.verifyOtp(
          username: 'jhon.doe@email.com',
          otpCode: '123456',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerException 500',
      () async {
        when(mockIOtpRemoteDataSource.verifyOtpRegister(any))
            .thenThrow(ServerException(false));

        final result = await otpRepository.verifyOtp(
          username: 'jhon.doe@email.com',
          otpCode: '123456',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownException',
      () async {
        when(mockIOtpRemoteDataSource.verifyOtpRegister(any))
            .thenThrow(UnknownException('unknown'));

        final result = await otpRepository.verifyOtp(
          username: 'jhon.doe@email.com',
          otpCode: '123456',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
