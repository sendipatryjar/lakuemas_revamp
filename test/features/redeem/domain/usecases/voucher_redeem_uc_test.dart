import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/redeem/domain/entities/voucher_redeemed_entity.dart';
import 'package:lakuemas/features/redeem/domain/usecases/voucher_redeem_uc.dart';
import 'package:mockito/mockito.dart';

import 'voucher_redeem_check_uc_test.mocks.dart';

void main() {
  late MockIVoucherRedeemRepository mockIVoucherRedeemRepository;
  late VoucherRedeemUc voucherRedeemUc;
  late VoucherRedeemedEntity voucherRedeemedEntity;

  setUpAll(() {
    mockIVoucherRedeemRepository = MockIVoucherRedeemRepository();
    voucherRedeemUc = VoucherRedeemUc(repository: mockIVoucherRedeemRepository);
    voucherRedeemedEntity = const VoucherRedeemedEntity(
      transactionId: 1,
      transactionCode: 'transactionCode',
      goldRedeemed: '5.0',
      status: 1,
      statusLabel: 'statusLabel',
    );
  });

  group('Voucher Redeem Usecase', () {
    test(
      'Success',
      () async {
        when(mockIVoucherRedeemRepository.redeem(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        )).thenAnswer((realInvocation) async => Right(voucherRedeemedEntity));

        final result = await voucherRedeemUc(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        );

        expect(result, Right(voucherRedeemedEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIVoucherRedeemRepository.redeem(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        )).thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await voucherRedeemUc(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIVoucherRedeemRepository.redeem(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        )).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await voucherRedeemUc(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIVoucherRedeemRepository.redeem(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        )).thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await voucherRedeemUc(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIVoucherRedeemRepository.redeem(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        )).thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await voucherRedeemUc(
          voucherCode: 'voucherCode',
          goldRedeemed: 5.0,
        );

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
