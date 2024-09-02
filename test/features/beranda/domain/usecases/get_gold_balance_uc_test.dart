import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/user/domain/entities/balance_entity.dart';
import 'package:lakuemas/features/beranda/domain/usecases/get_gold_balance_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_menus_uc_test.mocks.dart';

void main() {
  late MockIBerandaRepository mockIBerandaRepository;
  late BerandaGetBalancesUc berandaGetBalanceUc;
  late List<BalanceEntity> balances;

  setUpAll(() {
    mockIBerandaRepository = MockIBerandaRepository();
    berandaGetBalanceUc =
        BerandaGetBalancesUc(repository: mockIBerandaRepository);
    balances = const [
      BalanceEntity(
        customerId: 1,
        accountNumber: '123456789',
        gramationBalance: '5.0',
        nominalBalance: 200000,
        paymentMethodId: 1,
        transactionCode: 'transactionCode',
        transactionStatus: 1,
        type: 'type',
      ),
    ];
  });

  group('Gold Balance Usecase', () {
    test(
      'Success',
      () async {
        when(mockIBerandaRepository.getBalances())
            .thenAnswer((realInvocation) async => Right(balances));

        final result = await berandaGetBalanceUc();

        expect(result, Right(balances));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIBerandaRepository.getBalances())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await berandaGetBalanceUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIBerandaRepository.getBalances()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await berandaGetBalanceUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIBerandaRepository.getBalances())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await berandaGetBalanceUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIBerandaRepository.getBalances())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await berandaGetBalanceUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
