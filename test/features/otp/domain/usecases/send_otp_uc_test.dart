import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/otp/domain/repositories/i_otp_repository.dart';
import 'package:lakuemas/features/otp/domain/usecases/send_otp_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'send_otp_uc_test.mocks.dart';

@GenerateMocks([IOtpRepository])
void main() {
  late MockIOtpRepository mockIOtpRepository;
  late SendOtpUc sendOtpUc;

  setUpAll(() {
    mockIOtpRepository = MockIOtpRepository();
    sendOtpUc = SendOtpUc(repo: mockIOtpRepository);
  });

  group('send otp register uc', () {
    group('phone', () {
      String usernamePhone = '08123456789';
      int otpTypePhone = 1;

      test('success', () async {
        when(mockIOtpRepository.sendOtp(
          username: usernamePhone,
          otpType: otpTypePhone,
          otpLocation: 0,
        )).thenAnswer((realInvocation) async => const Right(true));

        final result = await sendOtpUc(SendOtpParams(
          username: usernamePhone,
          otpType: otpTypePhone,
          otpLocation: 0,
        ));

        expect(result, equals(const Right(true)));
      });

      test(
        'SessionFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 0,
          )).thenAnswer((realInvocation) async => Left(SessionFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 0,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<SessionFailure>());
        },
      );

      test(
        'ClientFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 0,
          )).thenAnswer(
              (realInvocation) async => const Left(MobileValidationFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 0,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<MobileValidationFailure>());
        },
      );

      test(
        'ServerFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 0,
          )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 0,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<ServerFailure>());
        },
      );

      test(
        'UnknownFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 0,
          )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 0,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    group('email', () {
      String usernameEmail = 'jhon.doe@email.com';
      int otpTypeEmail = 0;

      test('success', () async {
        when(mockIOtpRepository.sendOtp(
          username: usernameEmail,
          otpType: otpTypeEmail,
          otpLocation: 0,
        )).thenAnswer((realInvocation) async => const Right(true));

        final result = await sendOtpUc(SendOtpParams(
          username: usernameEmail,
          otpType: otpTypeEmail,
          otpLocation: 0,
        ));

        expect(result, equals(const Right(true)));
      });

      test(
        'SessionFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 0,
          )).thenAnswer((realInvocation) async => Left(SessionFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 0,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<SessionFailure>());
        },
      );

      test(
        'ClientFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 0,
          )).thenAnswer(
              (realInvocation) async => const Left(MobileValidationFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 0,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<MobileValidationFailure>());
        },
      );

      test(
        'ServerFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 0,
          )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 0,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<ServerFailure>());
        },
      );

      test(
        'UnknownFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 0,
          )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 0,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });

  //
  //
  group('send otp login uc', () {
    group('phone', () {
      String usernamePhone = '08123456789';
      int otpTypePhone = 1;

      test('success', () async {
        when(mockIOtpRepository.sendOtp(
          username: usernamePhone,
          otpType: otpTypePhone,
          otpLocation: 1,
        )).thenAnswer((realInvocation) async => const Right(true));

        final result = await sendOtpUc(SendOtpParams(
          username: usernamePhone,
          otpType: otpTypePhone,
          otpLocation: 1,
        ));

        expect(result, equals(const Right(true)));
      });

      test(
        'SessionFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => Left(SessionFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<SessionFailure>());
        },
      );

      test(
        'ClientFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 1,
          )).thenAnswer(
              (realInvocation) async => const Left(MobileValidationFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<MobileValidationFailure>());
        },
      );

      test(
        'ServerFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<ServerFailure>());
        },
      );

      test(
        'UnknownFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernamePhone,
            otpType: otpTypePhone,
            otpLocation: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });

    group('email', () {
      String usernameEmail = 'jhon.doe@email.com';
      int otpTypeEmail = 0;

      test('success', () async {
        when(mockIOtpRepository.sendOtp(
          username: usernameEmail,
          otpType: otpTypeEmail,
          otpLocation: 1,
        )).thenAnswer((realInvocation) async => const Right(true));

        final result = await sendOtpUc(SendOtpParams(
          username: usernameEmail,
          otpType: otpTypeEmail,
          otpLocation: 1,
        ));

        expect(result, equals(const Right(true)));
      });

      test(
        'SessionFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => Left(SessionFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<SessionFailure>());
        },
      );

      test(
        'ClientFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 1,
          )).thenAnswer(
              (realInvocation) async => const Left(MobileValidationFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<MobileValidationFailure>());
        },
      );

      test(
        'ServerFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<ServerFailure>());
        },
      );

      test(
        'UnknownFailure',
        () async {
          when(mockIOtpRepository.sendOtp(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 1,
          )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

          final result = await sendOtpUc(SendOtpParams(
            username: usernameEmail,
            otpType: otpTypeEmail,
            otpLocation: 1,
          ));

          expect(result, isA<Left>());

          final result2 = result.fold((l) => l, (r) => r);
          expect(result2, isA<UnknownFailure>());
        },
      );
    });
  });
}
