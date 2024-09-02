import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/user/domain/entities/balance_entity.dart';
import 'package:lakuemas/features/buy_gold/domain/usecases/get_balances_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_price_uc_test.mocks.dart';

void main() {
  late MockIBuyGoldRepository mockIBuyGoldRepository;
  late GetBalancesUc getBalancesUc;

  setUpAll(() {
    mockIBuyGoldRepository = MockIBuyGoldRepository();
    getBalancesUc = GetBalancesUc(repository: mockIBuyGoldRepository);
  });

  group('Get Balances Usecase', () {
    test(
      'Success',
      () async {
        when(mockIBuyGoldRepository.getBalances())
            .thenAnswer((realInvocation) async => const Right([]));

        final result = await getBalancesUc();

        expect(result, const Right<AppFailure, List<BalanceEntity>>([]));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIBuyGoldRepository.getBalances())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await getBalancesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIBuyGoldRepository.getBalances()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await getBalancesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIBuyGoldRepository.getBalances())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await getBalancesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIBuyGoldRepository.getBalances())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await getBalancesUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
