import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/register/domain/entities/register_entity.dart';
import 'package:lakuemas/features/register/domain/usecases/register_uc.dart';
import 'package:lakuemas/features/register/presentation/blocs/register/register_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_bloc_test.mocks.dart';

@GenerateMocks([RegisterUc])
void main() {
  late MockRegisterUc mockRegisterUc;
  late RegisterBloc registerBloc;

  setUp(() {
    mockRegisterUc = MockRegisterUc();
    registerBloc = RegisterBloc(registerUc: mockRegisterUc);
  });

  group('Success register', () {
    final registerParams = RegisterParams(
      fullName: 'jhon doe',
      phoneNumber: '08123456789',
      email: 'jhon.doe@email.com',
      password: 'password',
    );

    final registerEntity = RegisterEntity(
      id: 0,
      name: registerParams.fullName,
      phoneNumber: registerParams.phoneNumber,
      email: registerParams.email,
      createdAt: '',
      updatedAt: '',
    );

    final event = RegisterPressed(
      fullName: registerParams.fullName,
      phoneNumber: registerParams.phoneNumber,
      email: registerParams.email,
      password: registerParams.password,
    );

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockRegisterUc.call(any))
            .thenAnswer((realInvocation) async => Right(registerEntity));

        return registerBloc;
      },
      expectedStates: [
        RegisterLoading(),
        RegisterSuccess(registerEntity),
      ],
      verifyCall: () => verify(mockRegisterUc.call(any)),
    );
  });

  group('Error Register', () {
    final failureTypes = [
      SessionFailure(),
      const MobileValidationFailure(),
      const ServerFailure(),
      UnknownFailure(),
    ];

    final registerParams = RegisterParams(
      fullName: 'jhon doe',
      phoneNumber: '08123456789',
      email: 'jhon.doe@email.com',
      password: 'password',
    );

    final event = RegisterPressed(
      fullName: registerParams.fullName,
      phoneNumber: registerParams.phoneNumber,
      email: registerParams.email,
      password: registerParams.password,
    );

    for (final failureType in failureTypes) {
      blocTestWithCommonCases(
        description: failureType.runtimeType.toString(),
        event: event,
        build: () {
          when(mockRegisterUc.call(any))
              .thenAnswer((realInvocation) async => Left(failureType));

          return registerBloc;
        },
        expectedStates: [
          RegisterLoading(),
          if (failureType is SessionFailure)
            RegisterFailure(SessionFailure(), null, null),
          if (failureType is MobileValidationFailure)
            const RegisterFailure(MobileValidationFailure(), null, null),
          if (failureType is ServerFailure)
            const RegisterFailure(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            RegisterFailure(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockRegisterUc.call(any)),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required RegisterBloc Function() build,
  required List<RegisterState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<RegisterBloc, RegisterState>(
    'emits [Loading, $description] when MyEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
