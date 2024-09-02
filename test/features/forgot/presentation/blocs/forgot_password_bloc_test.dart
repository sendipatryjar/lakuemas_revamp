import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/forgot/domain/usecases/forgot_password_uc.dart';
import 'package:lakuemas/features/forgot/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgot_password_bloc_test.mocks.dart';

@GenerateMocks([ForgotPasswordUc])
void main() {
  late MockForgotPasswordUc mockForgotPasswordUc;
  late ForgotPasswordBloc forgotPasswordBloc;

  setUp(() {
    mockForgotPasswordUc = MockForgotPasswordUc();
    forgotPasswordBloc =
        ForgotPasswordBloc(forgotPasswordUc: mockForgotPasswordUc);
  });

  group('success forgot password', () {
    const String newPassword = 'secret';
    const String confirmPassword = 'secret';

    const event = ForgotPasswordPressedEvent(
      newPassword,
      confirmPassword,
    );

    blocTestWithCommonCases(
      description: 'Success',
      event: event,
      build: () {
        when(mockForgotPasswordUc.call(
          newPassword,
          confirmPassword,
        )).thenAnswer((_) async => const Right(true));

        return forgotPasswordBloc;
      },
      expectedStates: [
        ForgotPasswordLoadingState(),
        ForgotPasswordSuccessState(),
      ],
      verifyCall: () => verify(mockForgotPasswordUc.call(
        newPassword,
        confirmPassword,
      )),
    );
  });

  group('error forgot pasword', () {
    final failureTypes = [
      SessionFailure(),
      const MobileValidationFailure(),
      const ServerFailure(),
      UnknownFailure(),
    ];

    const String newPassword = 'secret';
    const String confirmPassword = 'secret';

    const event = ForgotPasswordPressedEvent(
      newPassword,
      confirmPassword,
    );

    for (final failureType in failureTypes) {
      blocTestWithCommonCases(
        description: failureType.runtimeType.toString(),
        event: event,
        build: () {
          when(mockForgotPasswordUc.call(
            newPassword,
            confirmPassword,
          )).thenAnswer((_) async => Left(failureType));

          return forgotPasswordBloc;
        },
        expectedStates: [
          ForgotPasswordLoadingState(),
          if (failureType is SessionFailure)
            ForgotPasswordFailureState(SessionFailure(), null, null),
          if (failureType is MobileValidationFailure)
            const ForgotPasswordFailureState(
                MobileValidationFailure(), null, null),
          if (failureType is ServerFailure)
            const ForgotPasswordFailureState(ServerFailure(), null, null),
          if (failureType is UnknownFailure)
            ForgotPasswordFailureState(UnknownFailure(), null, null),
        ],
        verifyCall: () => verify(mockForgotPasswordUc.call(
          newPassword,
          confirmPassword,
        )),
      );
    }
  });
}

void blocTestWithCommonCases({
  required String description,
  required dynamic event,
  required ForgotPasswordBloc Function() build,
  required List<ForgotPasswordState> expectedStates,
  required void Function() verifyCall,
}) {
  blocTest<ForgotPasswordBloc, ForgotPasswordState>(
    'emits [Loading, $description] when ForgotPasswordPressedEvent is added.',
    build: build,
    act: (bloc) => bloc.add(event),
    expect: () => expectedStates,
    verify: (_) => verifyCall(),
  );
}
