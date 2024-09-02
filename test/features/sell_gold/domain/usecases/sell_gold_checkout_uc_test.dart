import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/checkout_entity.dart';
import 'package:lakuemas/features/sell_gold/domain/usecases/sell_gold_checkout_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_balances_uc_test.mocks.dart';

void main() {
  late MockISellGoldRepository mockISellGoldRepository;
  late SellGoldCheckoutUc sellGoldCheckoutUc;
  late double? amount;
  late String? amountType;
  late CheckoutEntity checkoutEntity;

  setUpAll(() {
    mockISellGoldRepository = MockISellGoldRepository();
    sellGoldCheckoutUc =
        SellGoldCheckoutUc(repository: mockISellGoldRepository);
    amount = 2.0;
    amountType = 'amountType';
    checkoutEntity = CheckoutEntity(
      amount: amount.toString(),
      goldAmount: amount.toString(),
      goldPrice: '100000',
      nominalTax: '0',
      percentageTax: '0',
      grossAmount: '100025',
      transactionKey: 'qwertasdfgzxcvb',
    );
  });

  group('Get Price Usecase', () {
    test(
      'Success',
      () async {
        when(mockISellGoldRepository.checkout(
          amount: amount,
          amountType: amountType,
        )).thenAnswer((realInvocation) async => Right(checkoutEntity));

        final result = await sellGoldCheckoutUc(
          amount: amount,
          amountType: amountType,
        );

        expect(result, Right(checkoutEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockISellGoldRepository.checkout(
          amount: amount,
          amountType: amountType,
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await sellGoldCheckoutUc(
          amount: amount,
          amountType: amountType,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockISellGoldRepository.checkout(
          amount: amount,
          amountType: amountType,
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await sellGoldCheckoutUc(
          amount: amount,
          amountType: amountType,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockISellGoldRepository.checkout(
          amount: amount,
          amountType: amountType,
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await sellGoldCheckoutUc(
          amount: amount,
          amountType: amountType,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockISellGoldRepository.checkout(
          amount: amount,
          amountType: amountType,
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await sellGoldCheckoutUc(
          amount: amount,
          amountType: amountType,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
