import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/sell_gold/domain/entities/checkout_confirm_entity.dart';
import 'package:lakuemas/features/sell_gold/domain/usecases/sell_gold_checkout_confirm_uc.dart';
import 'package:mockito/mockito.dart';

import 'get_balances_uc_test.mocks.dart';

void main() {
  late MockISellGoldRepository mockISellGoldRepository;
  late SellGoldCheckoutConfirmUc sellGoldCheckoutConfirmUc;
  late String transactionKey;
  late CheckoutConfirmEntity checkoutConfirmEntity;

  setUpAll(() {
    mockISellGoldRepository = MockISellGoldRepository();
    sellGoldCheckoutConfirmUc =
        SellGoldCheckoutConfirmUc(repository: mockISellGoldRepository);
    transactionKey = 'transactionKey';
    checkoutConfirmEntity = const CheckoutConfirmEntity(
      transactionId: 1,
      transactionCode: 'transactionCode',
    );
  });

  group('Sell Gold Checkout Confirm Usecase', () {
    test(
      'Success',
      () async {
        when(mockISellGoldRepository.checkoutConfirm(
                transactionKey: transactionKey))
            .thenAnswer((realInvocation) async => Right(checkoutConfirmEntity));

        final result =
            await sellGoldCheckoutConfirmUc(transactionKey: transactionKey);

        expect(result, Right(checkoutConfirmEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockISellGoldRepository.checkoutConfirm(
                transactionKey: transactionKey))
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result =
            await sellGoldCheckoutConfirmUc(transactionKey: transactionKey);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockISellGoldRepository.checkoutConfirm(
                transactionKey: transactionKey))
            .thenAnswer((realInvocation) async =>
                const Left(MobileValidationFailure()));

        final result =
            await sellGoldCheckoutConfirmUc(transactionKey: transactionKey);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockISellGoldRepository.checkoutConfirm(
                transactionKey: transactionKey))
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result =
            await sellGoldCheckoutConfirmUc(transactionKey: transactionKey);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockISellGoldRepository.checkoutConfirm(
                transactionKey: transactionKey))
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result =
            await sellGoldCheckoutConfirmUc(transactionKey: transactionKey);

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
