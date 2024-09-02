import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/checkout_entity.dart';
import 'package:lakuemas/features/buy_gold/domain/usecases/checkout_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_price_uc_test.mocks.dart';

void main() {
  late MockIBuyGoldRepository mockIBuyGoldRepository;
  late CheckoutUc checkoutUc;
  late CheckoutEntity checkoutEntity;

  setUpAll(() {
    mockIBuyGoldRepository = MockIBuyGoldRepository();
    checkoutUc = CheckoutUc(repository: mockIBuyGoldRepository);
    checkoutEntity = const CheckoutEntity(
      amount: '100025',
      goldAmount: '0.2',
      goldPrice: '100000',
      nominalTax: '0',
      percentageTax: '0',
      grossAmount: '100025',
      transactionKey: 'qwertasdfgzxcvb',
    );
  });

  group('Checkout Usecase', () {
    test(
      'Success',
      () async {
        when(mockIBuyGoldRepository.checkout(
          amount: double.parse(checkoutEntity.amount ?? '0'),
          amountType: 'nominal',
        )).thenAnswer((realInvocation) async => Right(checkoutEntity));

        final result = await checkoutUc(
          amount: double.parse(checkoutEntity.amount ?? '0'),
          amountType: 'nominal',
        );

        expect(result, Right(checkoutEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIBuyGoldRepository.checkout())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await checkoutUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIBuyGoldRepository.checkout()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await checkoutUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIBuyGoldRepository.checkout())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await checkoutUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIBuyGoldRepository.checkout())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await checkoutUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
