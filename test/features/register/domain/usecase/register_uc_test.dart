import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/register/domain/entities/register_entity.dart';
import 'package:lakuemas/features/register/domain/repositories/i_register_repository.dart';
import 'package:lakuemas/features/register/domain/usecases/register_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_uc_test.mocks.dart';

@GenerateMocks([IRegisterRepository])
void main() {
  late MockIRegisterRepository mockIRegisterRepository;
  late RegisterUc registerUc;
  late RegisterEntity registerEntity;

  setUpAll(() {
    mockIRegisterRepository = MockIRegisterRepository();
    registerUc = RegisterUc(repo: mockIRegisterRepository);
    registerEntity = const RegisterEntity(
      id: 0,
      name: 'Jhon Doe',
      email: 'jhon.doe@email.com',
      phoneNumber: '08123456789',
      createdAt: '2023-03-20T10:47:57.983+07:00',
      updatedAt: '2023-03-20T10:47:57.983+07:00',
    );
  });

  group('Register Usecase', () {
    test(
      'Success',
      () async {
        when(mockIRegisterRepository.register(
          fullName: registerEntity.name,
          email: registerEntity.email,
          phoneNumber: registerEntity.phoneNumber,
          password: 'password',
        )).thenAnswer((realInvocation) async => Right(registerEntity));

        final result = await registerUc(
          RegisterParams(
            fullName: registerEntity.name!,
            phoneNumber: registerEntity.phoneNumber!,
            email: registerEntity.email!,
            password: 'password',
          ),
        );

        expect(result, Right(registerEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIRegisterRepository.register(
          fullName: registerEntity.name,
          email: registerEntity.email,
          phoneNumber: registerEntity.phoneNumber,
          password: 'password',
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await registerUc(
          RegisterParams(
            fullName: registerEntity.name!,
            phoneNumber: registerEntity.phoneNumber!,
            email: registerEntity.email!,
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
        when(mockIRegisterRepository.register(
          fullName: registerEntity.name,
          email: registerEntity.email,
          phoneNumber: registerEntity.phoneNumber,
          password: 'password',
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await registerUc(
          RegisterParams(
            fullName: registerEntity.name!,
            phoneNumber: registerEntity.phoneNumber!,
            email: registerEntity.email!,
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
        when(mockIRegisterRepository.register(
          fullName: registerEntity.name,
          email: registerEntity.email,
          phoneNumber: registerEntity.phoneNumber,
          password: 'password',
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await registerUc(
          RegisterParams(
            fullName: registerEntity.name!,
            phoneNumber: registerEntity.phoneNumber!,
            email: registerEntity.email!,
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
        when(mockIRegisterRepository.register(
          fullName: registerEntity.name,
          email: registerEntity.email,
          phoneNumber: registerEntity.phoneNumber,
          password: 'password',
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await registerUc(
          RegisterParams(
            fullName: registerEntity.name!,
            phoneNumber: registerEntity.phoneNumber!,
            email: registerEntity.email!,
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
