import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/cores/services/local_data_source/i_token_local_data_source.dart';
import 'package:lakuemas/features/login/data/data_sources/interfaces/i_login_remote_data_source.dart';
import 'package:lakuemas/features/login/data/models/login_model.dart';
import 'package:lakuemas/features/login/data/repositories/login_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_repository_test.mocks.dart';

@GenerateMocks([ILoginRemoteDataSource, ITokenLocalDataSource])
void main() {
  late MockILoginRemoteDataSource mockILoginRemoteDataSource;
  late MockITokenLocalDataSource mockITokenLocalDataSource;
  late LoginRepository loginRepository;
  late LoginModel loginModel;

  setUpAll(() {
    mockILoginRemoteDataSource = MockILoginRemoteDataSource();
    mockITokenLocalDataSource = MockITokenLocalDataSource();
    loginRepository = LoginRepository(
        remoteDataSource: mockILoginRemoteDataSource,
        tokenLocalDataSource: mockITokenLocalDataSource);
    loginModel = const LoginModel(
      phoneNumber: '08123456789',
      email: 'jhon.doe@email.com',
    );
  });

  group('Login Repository', () {
    test(
      'Success 200',
      () async {
        when(mockILoginRemoteDataSource.login(any))
            .thenAnswer((realInvocation) async => BaseResp<LoginModel>(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                  data: LoginModel(
                    email: loginModel.email,
                    phoneNumber: loginModel.phoneNumber,
                  ),
                ));

        final result = await loginRepository.login(
          userName: loginModel.email,
          password: 'password',
          firebaseToken: '',
        );

        expect(result, Right(loginModel));
      },
    );

    test(
      'SessionException 401',
      () async {
        when(mockILoginRemoteDataSource.login(any))
            .thenThrow(SessionException());

        final result = await loginRepository.login(
          userName: loginModel.email,
          password: 'password',
          firebaseToken: '',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientException 400 or 422',
      () async {
        when(mockILoginRemoteDataSource.login(any)).thenThrow(
            ClientException(400, 'The request parameter invalid', null));

        final result = await loginRepository.login(
          userName: loginModel.email,
          password: 'password',
          firebaseToken: '',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerException 500',
      () async {
        when(mockILoginRemoteDataSource.login(any))
            .thenThrow(ServerException(false));

        final result = await loginRepository.login(
          userName: loginModel.email,
          password: 'password',
          firebaseToken: '',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownException',
      () async {
        when(mockILoginRemoteDataSource.login(any))
            .thenThrow(UnknownException('unknown'));

        final result = await loginRepository.login(
          userName: loginModel.email,
          password: 'password',
          firebaseToken: '',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
