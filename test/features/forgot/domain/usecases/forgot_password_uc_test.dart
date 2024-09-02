import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/forgot/domain/repositories/i_forgot_password_repository.dart';
import 'package:lakuemas/features/forgot/domain/usecases/forgot_password_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgot_password_uc_test.mocks.dart';

@GenerateMocks([IForgotPasswordRepository])
void main() {
  late MockIForgotPasswordRepository mockIForgotPasswordRepository;
  late ForgotPasswordUc forgotPasswordUc;

  setUp(() {
    mockIForgotPasswordRepository = MockIForgotPasswordRepository();
    forgotPasswordUc =
        ForgotPasswordUc(repository: mockIForgotPasswordRepository);
  });

  const String newPassword = 'secret';
  const String confirmPassword = 'secret';

  test('Success Forgot Password', () async {
    when(mockIForgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    )).thenAnswer((_) async => const Right(true));

    final result = await forgotPasswordUc(
      newPassword,
      confirmPassword,
    );
    expect(result, const Right(true));
  });

  test('Forgot Password Session Failure', () async {
    when(mockIForgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    )).thenAnswer((_) async => Left(SessionFailure()));

    final result = await forgotPasswordUc(
      newPassword,
      confirmPassword,
    );
    expect(result, Left(SessionFailure()));
  });

  test('Forgot Password Client Failure', () async {
    when(mockIForgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    )).thenAnswer(
      (_) async => const Left(
        ClientFailure(
          code: 400,
          messages: 'email can not be empty',
          errors: {'field': 'field not be empty'},
        ),
      ),
    );

    final result = await forgotPasswordUc(
      newPassword,
      confirmPassword,
    );
    expect(
      result,
      const Left(
        ClientFailure(
          code: 400,
          messages: 'email can not be empty',
          errors: {'field': 'field not be empty'},
        ),
      ),
    );
  });

  test('Forgot Password Server Failure', () async {
    when(mockIForgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    )).thenAnswer(
      (_) async => const Left(ServerFailure()),
    );

    final result = await forgotPasswordUc(
      newPassword,
      confirmPassword,
    );
    expect(result, const Left(ServerFailure()));
  });

  test('Forgot Password Unknown Failure', () async {
    when(mockIForgotPasswordRepository.forgot(
      newPassword,
      confirmPassword,
    )).thenAnswer(
      (_) async => Left(UnknownFailure()),
    );

    final result = await forgotPasswordUc(
      newPassword,
      confirmPassword,
    );
    expect(result, Left(UnknownFailure()));
  });
}
