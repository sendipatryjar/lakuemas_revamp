import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/laku_save/domain/usecases/lakusave_checkout_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_about_uc_test.mocks.dart';

void main() {
  late MockILakusaveRepository mockILakusaveRepository;
  late LakusaveCheckoutUc lakusaveCheckoutUc;
  late LakusaveChekcoutParams req;
  late bool res;

  setUpAll(() {
    mockILakusaveRepository = MockILakusaveRepository();
    lakusaveCheckoutUc =
        LakusaveCheckoutUc(repository: mockILakusaveRepository);
    req = LakusaveChekcoutParams(
      durationId: 1,
      extendedId: 1,
      goldWeight: 2.0,
      accountNumber: '123456789',
      accountNumberDest: '987654321',
    );
    res = true;
  });

  group('Lakusave Checkout Usecase', () {
    test(
      'Success',
      () async {
        when(mockILakusaveRepository.checkout(
          request: req,
        )).thenAnswer((realInvocation) async => Right(res));

        final result = await lakusaveCheckoutUc(req);

        expect(result, Right(res));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockILakusaveRepository.checkout(
          request: req,
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await lakusaveCheckoutUc(req);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockILakusaveRepository.checkout(
          request: req,
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await lakusaveCheckoutUc(req);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockILakusaveRepository.checkout(
          request: req,
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await lakusaveCheckoutUc(req);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockILakusaveRepository.checkout(
          request: req,
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await lakusaveCheckoutUc(req);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
