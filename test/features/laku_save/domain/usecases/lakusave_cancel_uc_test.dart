import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/laku_save/domain/usecases/lakusave_cancel_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_about_uc_test.mocks.dart';

void main() {
  late MockILakusaveRepository mockILakusaveRepository;
  late LakusaveCancelUc lakusaveCancelUc;
  late bool res;

  setUpAll(() {
    mockILakusaveRepository = MockILakusaveRepository();
    lakusaveCancelUc = LakusaveCancelUc(repository: mockILakusaveRepository);
    res = true;
  });

  group('Lakusave Cancel Usecase', () {
    test(
      'Success',
      () async {
        when(mockILakusaveRepository.cancel(transactionCode: 'transactionCode'))
            .thenAnswer((realInvocation) async => Right(res));

        final result =
            await lakusaveCancelUc(transactionCode: 'transactionCode');

        expect(result, Right(res));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockILakusaveRepository.cancel(transactionCode: 'transactionCode'))
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result =
            await lakusaveCancelUc(transactionCode: 'transactionCode');

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockILakusaveRepository.cancel(transactionCode: 'transactionCode'))
            .thenAnswer((realInvocation) async =>
                const Left(MobileValidationFailure()));

        final result =
            await lakusaveCancelUc(transactionCode: 'transactionCode');

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockILakusaveRepository.cancel(transactionCode: 'transactionCode'))
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result =
            await lakusaveCancelUc(transactionCode: 'transactionCode');

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockILakusaveRepository.cancel(transactionCode: 'transactionCode'))
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result =
            await lakusaveCancelUc(transactionCode: 'transactionCode');

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
