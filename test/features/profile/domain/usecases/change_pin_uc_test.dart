import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/profile/domain/usecases/change_pin_uc.dart';
import 'package:mockito/mockito.dart';

import 'change_password_uc_test.mocks.dart';

void main() {
  late MockIProfileRepository mockIProfileRepository;
  late ChangePinUc changePinUc;

  setUpAll(() {
    mockIProfileRepository = MockIProfileRepository();
    changePinUc = ChangePinUc(repository: mockIProfileRepository);
  });

  group('Change PIN Usecase', () {
    test(
      'Success',
      () async {
        when(mockIProfileRepository.changePin(
          oldPin: '123456',
          newPin: 'qwerty',
          newPinConfirmation: 'qwerty',
        )).thenAnswer((realInvocation) async => const Right(true));

        final result = await changePinUc(
          ChangePinParams(
            oldPin: '123456',
            newPin: 'qwerty',
            newPinConfirmation: 'qwerty',
          ),
        );

        expect(result, const Right(true));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIProfileRepository.changePin(
          oldPin: '123456',
          newPin: 'qwerty',
          newPinConfirmation: 'qwerty',
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await changePinUc(
          ChangePinParams(
            oldPin: '123456',
            newPin: 'qwerty',
            newPinConfirmation: 'qwerty',
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
        when(mockIProfileRepository.changePin(
          oldPin: '123456',
          newPin: 'qwerty',
          newPinConfirmation: 'qwerty',
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await changePinUc(
          ChangePinParams(
            oldPin: '123456',
            newPin: 'qwerty',
            newPinConfirmation: 'qwerty',
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
        when(mockIProfileRepository.changePin(
          oldPin: '123456',
          newPin: 'qwerty',
          newPinConfirmation: 'qwerty',
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await changePinUc(
          ChangePinParams(
            oldPin: '123456',
            newPin: 'qwerty',
            newPinConfirmation: 'qwerty',
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
        when(mockIProfileRepository.changePin(
          oldPin: '123456',
          newPin: 'qwerty',
          newPinConfirmation: 'qwerty',
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await changePinUc(
          ChangePinParams(
            oldPin: '123456',
            newPin: 'qwerty',
            newPinConfirmation: 'qwerty',
          ),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
