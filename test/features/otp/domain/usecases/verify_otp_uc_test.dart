import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/otp/domain/usecases/verify_otp_uc.dart';
import 'package:mockito/mockito.dart';

import 'send_otp_uc_test.mocks.dart';

void main() {
  late MockIOtpRepository mockIOtpRepository;
  late VerifyOtpUc verifyOtpUc;

  setUpAll(() {
    mockIOtpRepository = MockIOtpRepository();
    verifyOtpUc = VerifyOtpUc(repo: mockIOtpRepository);
  });

  group('verify otp uc', () {
    group('phone', () {
      String usernamePhone = '08123456789';
      String otpCode = '123456';

      test('success', () async {
        when(mockIOtpRepository.verifyOtp(
          username: usernamePhone,
          otpCode: otpCode,
          otpLocation: 1,
        )).thenAnswer((realInvocation) async => const Right(true));

        final result = await verifyOtpUc(VerifyOtpParams(
          username: usernamePhone,
          otpCode: otpCode,
          otpLocation: 1,
          otpType: 1,
        ));

        expect(result, equals(const Right(true)));
      });

      test(
        'SessionFailure',
        () async {
          when(mockIOtpRepository.verifyOtp(
            username: usernamePhone,
            otpCode: otpCode,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => Left(SessionFailure()));

          final result = await verifyOtpUc(VerifyOtpParams(
            username: usernamePhone,
            otpCode: otpCode,
            otpLocation: 1,
            otpType: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<SessionFailure>());
        },
      );

      test(
        'ClientFailure',
        () async {
          when(mockIOtpRepository.verifyOtp(
            username: usernamePhone,
            otpCode: otpCode,
            otpLocation: 1,
          )).thenAnswer(
              (realInvocation) async => const Left(MobileValidationFailure()));

          final result = await verifyOtpUc(VerifyOtpParams(
            username: usernamePhone,
            otpCode: otpCode,
            otpLocation: 1,
            otpType: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<MobileValidationFailure>());
        },
      );

      test(
        'ServerFailure',
        () async {
          when(mockIOtpRepository.verifyOtp(
            username: usernamePhone,
            otpCode: otpCode,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

          final result = await verifyOtpUc(VerifyOtpParams(
            username: usernamePhone,
            otpCode: otpCode,
            otpLocation: 1,
            otpType: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<ServerFailure>());
        },
      );

      test(
        'UnknownFailure',
        () async {
          when(mockIOtpRepository.verifyOtp(
            username: usernamePhone,
            otpCode: otpCode,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

          final result = await verifyOtpUc(VerifyOtpParams(
            username: usernamePhone,
            otpCode: otpCode,
            otpLocation: 1,
            otpType: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    group('email', () {
      String usernameEmail = 'jhon.doe@email.com';
      String otpCode = '123456';

      test('success', () async {
        when(mockIOtpRepository.verifyOtp(
          username: usernameEmail,
          otpCode: otpCode,
          otpLocation: 1,
        )).thenAnswer((realInvocation) async => const Right(true));

        final result = await verifyOtpUc(VerifyOtpParams(
          username: usernameEmail,
          otpCode: otpCode,
          otpLocation: 1,
          otpType: 2,
        ));

        expect(result, equals(const Right(true)));
      });

      test(
        'SessionFailure',
        () async {
          when(mockIOtpRepository.verifyOtp(
            username: usernameEmail,
            otpCode: otpCode,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => Left(SessionFailure()));

          final result = await verifyOtpUc(VerifyOtpParams(
            username: usernameEmail,
            otpCode: otpCode,
            otpLocation: 1,
            otpType: 2,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<SessionFailure>());
        },
      );

      test(
        'ClientFailure',
        () async {
          when(mockIOtpRepository.verifyOtp(
            username: usernameEmail,
            otpCode: otpCode,
            otpLocation: 1,
          )).thenAnswer(
              (realInvocation) async => const Left(MobileValidationFailure()));

          final result = await verifyOtpUc(VerifyOtpParams(
            username: usernameEmail,
            otpCode: otpCode,
            otpLocation: 1,
            otpType: 2,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<MobileValidationFailure>());
        },
      );

      test(
        'ServerFailure',
        () async {
          when(mockIOtpRepository.verifyOtp(
            username: usernameEmail,
            otpCode: otpCode,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

          final result = await verifyOtpUc(VerifyOtpParams(
            username: usernameEmail,
            otpCode: otpCode,
            otpLocation: 1,
            otpType: 2,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<ServerFailure>());
        },
      );

      test(
        'UnknownFailure',
        () async {
          when(mockIOtpRepository.verifyOtp(
            username: usernameEmail,
            otpCode: otpCode,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

          final result = await verifyOtpUc(VerifyOtpParams(
            username: usernameEmail,
            otpCode: otpCode,
            otpLocation: 1,
            otpType: 2,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
