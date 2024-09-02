import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/forgot/data/data_sources/interfaces/i_forgot_password_remote_data_source.dart';
import 'package:lakuemas/features/forgot/data/repositories/forgot_password_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgot_password_repository_test.mocks.dart';

@GenerateMocks([
  IForgotPasswordRemoteDataSource,
  ITokenLocalDataSource,
])
void main() {
  late MockIForgotPasswordRemoteDataSource mockIForgotPasswordRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late ForgotPasswordRepository forgotPasswordRepository;

  setUp(() {
    mockIForgotPasswordRemoteDataSource = MockIForgotPasswordRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();

    forgotPasswordRepository = ForgotPasswordRepository(
      remoteDataSource: mockIForgotPasswordRemoteDataSource,
      tokenLocalDataSource: mockITokenLocalDataSource,
    );
  });

  const String newPassword = 'secret';
  const String confirmPassword = 'secret';
  const String accessToken = 'accessToken';
  const String refreshToken = 'refreshToken';

  /// SUCCESS
  test('success 200', () async {
    when(mockITokenLocalDataSource.getAccessToken())
        .thenAnswer((realInvocation) async => accessToken);
    when(mockITokenLocalDataSource.getRefreshToken())
        .thenAnswer((realInvocation) async => refreshToken);
    when(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    )).thenAnswer(
      (_) async => BaseResp(
        code: 200,
        msgKey: 'SUCCESS',
        message: 'SUCCESS',
      ),
    );

    final result = await forgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    );

    verify(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    ));
    expect(result, const Right(true));
  });

  //
  //
  /// ERROR
  test('Session Failure when call remote data source', () async {
    when(mockITokenLocalDataSource.getAccessToken())
        .thenAnswer((realInvocation) async => accessToken);
    when(mockITokenLocalDataSource.getRefreshToken())
        .thenAnswer((realInvocation) async => refreshToken);
    when(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    )).thenThrow(SessionException());

    final result = await forgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    );
    verify(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    ));

    expect(result, equals(Left(SessionFailure())));
  });

  test('Client Failure when call remote data source', () async {
    when(mockITokenLocalDataSource.getAccessToken())
        .thenAnswer((realInvocation) async => accessToken);
    when(mockITokenLocalDataSource.getRefreshToken())
        .thenAnswer((realInvocation) async => refreshToken);
    when(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    )).thenThrow(
      ClientException(
        400,
        'email can not be null',
        {'field': 'field cannot be empty'},
      ),
    );

    final result = await forgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    );
    verify(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    ));

    expect(
      result,
      equals(
        const Left(
          ClientFailure(
            code: 400,
            messages: 'email can not be null',
            errors: {'field': 'field cannot be empty'},
          ),
        ),
      ),
    );
  });

  test('Server Failure when call remote data source', () async {
    when(mockITokenLocalDataSource.getAccessToken())
        .thenAnswer((realInvocation) async => accessToken);
    when(mockITokenLocalDataSource.getRefreshToken())
        .thenAnswer((realInvocation) async => refreshToken);
    when(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    )).thenThrow(ServerException(false));

    final result = await forgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    );
    verify(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    ));

    expect(result, equals(const Left(ServerFailure())));
  });

  test('Unknown Failure when call remote data source', () async {
    when(mockITokenLocalDataSource.getAccessToken())
        .thenAnswer((realInvocation) async => accessToken);
    when(mockITokenLocalDataSource.getRefreshToken())
        .thenAnswer((realInvocation) async => refreshToken);
    when(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    )).thenThrow(UnknownException('unknown'));

    final result = await forgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    );
    verify(mockIForgotPasswordRemoteDataSource.forgot(
      accessToken,
      refreshToken,
      newPassword,
      confirmPassword,
    ));

    expect(result, equals(Left(UnknownFailure())));
  });
}
