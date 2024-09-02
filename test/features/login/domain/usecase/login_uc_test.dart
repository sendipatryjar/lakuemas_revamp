import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/services/firebase/firebase_messaging_service.dart';
import 'package:lakuemas/features/login/domain/entities/login_entity.dart';
import 'package:lakuemas/features/login/domain/repositories/i_login_repository.dart';
import 'package:lakuemas/features/login/domain/usecases/login_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_uc_test.mocks.dart';

@GenerateMocks([ILoginRepository])
void main() {
  late MockILoginRepository mockILoginRepository;
  late LoginUc loginUc;
  late LoginEntity loginEntity;

  setUpAll(() {
    mockILoginRepository = MockILoginRepository();
    loginUc = LoginUc(repo: mockILoginRepository);
    loginEntity = const LoginEntity(
      accessToken: 'accesstoken',
      refreshToken: 'refreshtoken',
      email: 'jhon.doe@email.com',
      phoneNumber: '08123456789',
    );
  });

  group('Login Usecase', () {
    test(
      'Success',
      () async {
        when(mockILoginRepository.login(
          userName: 'jhondoe',
          password: 'password',
          firebaseToken: FirebaseMessagingService.token,
        )).thenAnswer((realInvocation) async => Right(loginEntity));

        final result = await loginUc(
          LoginParams(
            userName: 'jhondoe',
            password: 'password',
          ),
        );

        expect(result, Right(loginEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockILoginRepository.login(
          userName: 'jhondoe',
          password: 'password',
          firebaseToken: FirebaseMessagingService.token,
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await loginUc(
          LoginParams(
            userName: 'jhondoe',
            password: 'password',
          ),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockILoginRepository.login(
          userName: 'jhondoe',
          password: 'password',
          firebaseToken: FirebaseMessagingService.token,
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await loginUc(
          LoginParams(
            userName: 'jhondoe',
            password: 'password',
          ),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockILoginRepository.login(
          userName: 'jhondoe',
          password: 'password',
          firebaseToken: FirebaseMessagingService.token,
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await loginUc(
          LoginParams(
            userName: 'jhondoe',
            password: 'password',
          ),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockILoginRepository.login(
          userName: 'jhondoe',
          password: 'password',
          firebaseToken: FirebaseMessagingService.token,
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await loginUc(
          LoginParams(
            userName: 'jhondoe',
            password: 'password',
          ),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
