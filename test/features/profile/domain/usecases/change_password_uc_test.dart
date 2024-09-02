import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/profile/domain/repositories/i_profile_repository.dart';
import 'package:lakuemas/features/profile/domain/usecases/change_password_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_uc_test.mocks.dart';

@GenerateMocks([IProfileRepository])
void main() {
  late MockIProfileRepository mockIProfileRepository;
  late ChangePasswordUc changePasswordUc;

  setUpAll(() {
    mockIProfileRepository = MockIProfileRepository();
    changePasswordUc = ChangePasswordUc(repository: mockIProfileRepository);
  });

  group('Change Password Usecase', () {
    test(
      'Success',
      () async {
        when(mockIProfileRepository.changePassword(
          oldPassword: '123456',
          newPassword: 'qwerty',
          newPasswordConfirmation: 'qwerty',
        )).thenAnswer((realInvocation) async => const Right(true));

        final result = await changePasswordUc(
          ChangePasswordParams(
            oldPassword: '123456',
            newPassword: 'qwerty',
            newPasswordConfirmation: 'qwerty',
          ),
        );

        expect(result, const Right(true));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIProfileRepository.changePassword(
          oldPassword: '123456',
          newPassword: 'qwerty',
          newPasswordConfirmation: 'qwerty',
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await changePasswordUc(
          ChangePasswordParams(
            oldPassword: '123456',
            newPassword: 'qwerty',
            newPasswordConfirmation: 'qwerty',
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
        when(mockIProfileRepository.changePassword(
          oldPassword: '123456',
          newPassword: 'qwerty',
          newPasswordConfirmation: 'qwerty',
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await changePasswordUc(
          ChangePasswordParams(
            oldPassword: '123456',
            newPassword: 'qwerty',
            newPasswordConfirmation: 'qwerty',
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
        when(mockIProfileRepository.changePassword(
          oldPassword: '123456',
          newPassword: 'qwerty',
          newPasswordConfirmation: 'qwerty',
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await changePasswordUc(
          ChangePasswordParams(
            oldPassword: '123456',
            newPassword: 'qwerty',
            newPasswordConfirmation: 'qwerty',
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
        when(mockIProfileRepository.changePassword(
          oldPassword: '123456',
          newPassword: 'qwerty',
          newPasswordConfirmation: 'qwerty',
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await changePasswordUc(
          ChangePasswordParams(
            oldPassword: '123456',
            newPassword: 'qwerty',
            newPasswordConfirmation: 'qwerty',
          ),
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
