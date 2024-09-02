import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/transfer/domain/entities/transfer_charge_entity.dart';
import 'package:lakuemas/features/transfer/domain/usecases/transfer_charge_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_user_favorites_uc_test.mocks.dart';

void main() {
  late MockITransferRepository mockITransferRepository;
  late TransferChargeUc transferChargeUc;

  setUp(() {
    mockITransferRepository = MockITransferRepository();
    transferChargeUc = TransferChargeUc(repository: mockITransferRepository);
  });

  group('transfer charge', () {
    const bool isAddFavorite = true;
    const double goldWeight = 11.0;
    const String accountNumber = '111111';

    const transferChargeEntity = TransferChargeEntity(
      accountName: 'abogoboga',
      accountNumber: '111111',
      goldWeight: '11',
      transactionKey: 'PRE111000',
    );

    // ERROR
    test('success', () async {
      when(mockITransferRepository.transferCharge(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      )).thenAnswer((_) async => const Right(transferChargeEntity));

      final result = await transferChargeUc.call(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      );
      expect(result, const Right(transferChargeEntity));
    });

    // ERROR
    test('session failure', () async {
      when(mockITransferRepository.transferCharge(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      )).thenAnswer((_) async => Left(SessionFailure()));

      final result = await transferChargeUc.call(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      );
      expect(result, Left(SessionFailure()));
    });

    test('client failure', () async {
      when(mockITransferRepository.transferCharge(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      )).thenAnswer(
        (_) async => const Left(
          ClientFailure(
            code: 400,
            messages: 'email can not be empty',
            errors: {'field': 'field not be empty'},
          ),
        ),
      );

      final result = await transferChargeUc.call(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
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
      when(mockITransferRepository.transferCharge(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      )).thenAnswer(
        (_) async => const Left(ServerFailure()),
      );

      final result = await transferChargeUc.call(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      );
      expect(result, const Left(ServerFailure()));
    });

    test('unknown failure', () async {
      when(mockITransferRepository.transferCharge(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      )).thenAnswer(
        (_) async => Left(UnknownFailure()),
      );

      final result = await transferChargeUc.call(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
      );
      expect(result, Left(UnknownFailure()));
    });
  });
}
