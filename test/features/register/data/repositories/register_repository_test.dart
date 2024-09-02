import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/cores/errors/exceptions/api_exception.dart';
import 'package:lakuemas/cores/models/base_resp.dart';
import 'package:lakuemas/features/register/data/data_source/interfaces/i_register_remote_data_source.dart';
import 'package:lakuemas/features/register/data/models/register_model.dart';
import 'package:lakuemas/features/register/data/repositories/register_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_repository_test.mocks.dart';

@GenerateMocks([IRegisterRemoteDataSource])
void main() {
  late MockIRegisterRemoteDataSource mockIRegisterRemoteDataSource;
  late RegisterRepository registerRepository;
  late RegisterModel registerModel;

  setUpAll(() {
    mockIRegisterRemoteDataSource = MockIRegisterRemoteDataSource();
    registerRepository =
        RegisterRepository(remoteDataSource: mockIRegisterRemoteDataSource);
    registerModel = const RegisterModel(
      id: 0,
      name: 'Jhon Doe',
      phoneNumber: '08123456789',
      email: 'jhon.doe@email.com',
      createdAt: '2023-03-20T10:47:57.983+07:00',
      updatedAt: '2023-03-20T10:47:57.983+07:00',
    );
  });

  group('Register Repository', () {
    test(
      'Success 200',
      () async {
        when(mockIRegisterRemoteDataSource.register(any))
            .thenAnswer((realInvocation) async => BaseResp<RegisterModel>(
                  code: 200,
                  msgKey: 'SUCCESS',
                  message: 'SUCCESS',
                  data: RegisterModel(
                    id: 0,
                    name: registerModel.name,
                    email: registerModel.email,
                    phoneNumber: registerModel.phoneNumber,
                    createdAt: registerModel.createdAt,
                    updatedAt: registerModel.updatedAt,
                  ),
                ));

        final result = await registerRepository.register(
          fullName: registerModel.name!,
          phoneNumber: registerModel.phoneNumber!,
          email: registerModel.email!,
          password: 'password',
        );

        expect(result, Right(registerModel));
      },
    );

    test(
      'SessionException 401',
      () async {
        when(mockIRegisterRemoteDataSource.register(any))
            .thenThrow(SessionException());

        final result = await registerRepository.register(
          fullName: registerModel.name!,
          phoneNumber: registerModel.phoneNumber!,
          email: registerModel.email!,
          password: 'password',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientException 400 or 422',
      () async {
        when(mockIRegisterRemoteDataSource.register(any))
            .thenThrow(ClientException(
          400,
          'The request parameter invalid',
          null,
        ));

        final result = await registerRepository.register(
          fullName: registerModel.name!,
          phoneNumber: registerModel.phoneNumber!,
          email: registerModel.email!,
          password: 'password',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerException 500',
      () async {
        when(mockIRegisterRemoteDataSource.register(any))
            .thenThrow(ServerException(false));

        final result = await registerRepository.register(
          fullName: registerModel.name!,
          phoneNumber: registerModel.phoneNumber!,
          email: registerModel.email!,
          password: 'password',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownException',
      () async {
        when(mockIRegisterRemoteDataSource.register(any))
            .thenThrow(UnknownException('unknown'));

        final result = await registerRepository.register(
          fullName: registerModel.name!,
          phoneNumber: registerModel.phoneNumber!,
          email: registerModel.email!,
          password: 'password',
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
