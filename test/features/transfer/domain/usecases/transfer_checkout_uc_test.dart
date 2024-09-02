import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/transfer/domain/entities/transfer_checkout_entity.dart';
import 'package:lakuemas/features/transfer/domain/usecases/transfer_checkout_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_user_favorites_uc_test.mocks.dart';

void main() {
  late MockITransferRepository mockITransferRepository;
  late TransferCheckoutUc transferCheckoutUc;

  setUp(() {
    mockITransferRepository = MockITransferRepository();
    transferCheckoutUc =
        TransferCheckoutUc(repository: mockITransferRepository);
  });

  group('transfer checkout', () {
    const String trxKey = '111111111';

    const transferCheckoutEntity = TransferCheckoutEntity(
      transactionCode: '1111111111111',
    );

    // SUCCESS
    test('success', () async {
      when(mockITransferRepository.transferCheckout(
        transactionKey: trxKey,
      )).thenAnswer((_) async => const Right(transferCheckoutEntity));

      final result = await transferCheckoutUc.call(
        transactionKey: trxKey,
      );
      expect(result, const Right(transferCheckoutEntity));
    });

    // ERROR
    test('session failure', () async {
      when(mockITransferRepository.transferCheckout(
        transactionKey: trxKey,
      )).thenAnswer((_) async => Left(SessionFailure()));

      final result = await transferCheckoutUc.call(
        transactionKey: trxKey,
      );
      expect(result, Left(SessionFailure()));
    });

    test('client failure', () async {
      when(mockITransferRepository.transferCheckout(
        transactionKey: trxKey,
      )).thenAnswer(
        (_) async => const Left(
          ClientFailure(
            code: 400,
            messages: 'email can not be empty',
            errors: {'field': 'field not be empty'},
          ),
        ),
      );

      final result = await transferCheckoutUc.call(
        transactionKey: trxKey,
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

    test('server failure', () async {
      when(mockITransferRepository.transferCheckout(
        transactionKey: trxKey,
      )).thenAnswer(
        (_) async => const Left(ServerFailure()),
      );

      final result = await transferCheckoutUc.call(
        transactionKey: trxKey,
      );
      expect(result, const Left(ServerFailure()));
    });

    test('unknown failure', () async {
      when(mockITransferRepository.transferCheckout(
        transactionKey: trxKey,
      )).thenAnswer(
        (_) async => Left(UnknownFailure()),
      );

      final result = await transferCheckoutUc.call(
        transactionKey: trxKey,
      );
      expect(result, Left(UnknownFailure()));
    });
  });
}
