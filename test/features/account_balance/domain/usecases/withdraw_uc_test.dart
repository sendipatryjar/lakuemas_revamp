import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/account_balance/domain/entities/withdrawal_entity.dart';
import 'package:lakuemas/features/account_balance/domain/usecases/withdraw_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_bank_me_uc_test.mocks.dart';

void main() {
  late MockIAccountBalanceRepository mockIAccountBalanceRepository;
  late WithdrawUc withdrawUc;
  late WithdrawalEntity withdrawalEntity;
  late int amount;

  setUpAll(() {
    mockIAccountBalanceRepository = MockIAccountBalanceRepository();
    withdrawUc = WithdrawUc(repository: mockIAccountBalanceRepository);
    amount = 250000;
    withdrawalEntity = const WithdrawalEntity(
      transactionId: 1,
      status: 1,
      amount: '250000',
      grossAmount: '400000',
      serviceFee: '3000',
      transactionCode: 'transactionCode',
    );
  });

  group('Withdraw Usecase', () {
    test(
      'Success',
      () async {
        when(mockIAccountBalanceRepository.withdraw(amount: amount))
            .thenAnswer((realInvocation) async => Right(withdrawalEntity));

        final result = await withdrawUc(amount: amount);

        expect(result, Right(withdrawalEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIAccountBalanceRepository.withdraw(amount: amount))
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await withdrawUc(amount: amount);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIAccountBalanceRepository.withdraw(amount: amount)).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await withdrawUc(amount: amount);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIAccountBalanceRepository.withdraw(amount: amount))
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await withdrawUc(amount: amount);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIAccountBalanceRepository.withdraw(amount: amount))
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await withdrawUc(amount: amount);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
