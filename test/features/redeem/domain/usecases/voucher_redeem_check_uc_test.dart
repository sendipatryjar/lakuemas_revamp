import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/cores/errors/app_failure.dart';
import 'package:lakuemas/features/redeem/domain/entities/voucher_redeem_entity.dart';
import 'package:lakuemas/features/redeem/domain/repositories/i_voucher_redeem_repository.dart';
import 'package:lakuemas/features/redeem/domain/usecases/voucher_redeem_check_uc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'voucher_redeem_check_uc_test.mocks.dart';

@GenerateMocks([IVoucherRedeemRepository])
void main() {
  late MockIVoucherRedeemRepository mockIVoucherRedeemRepository;
  late VoucherRedeemCheckUc voucherRedeemCheckUc;
  late VoucherRedeemEntity voucherRedeemEntity;

  setUpAll(() {
    mockIVoucherRedeemRepository = MockIVoucherRedeemRepository();
    voucherRedeemCheckUc =
        VoucherRedeemCheckUc(repository: mockIVoucherRedeemRepository);
    voucherRedeemEntity = const VoucherRedeemEntity(
      code: 'code',
      goldRedeemed: '5.0',
      name: 'name',
      purchasePrice: '980000',
      sellingPrice: '970000',
      tax: '0',
      amount: '100025',
      goldAmount: '0.2',
    );
  });

  group('Voucher Redeem Check Usecase', () {
    test(
      'Success',
      () async {
        when(mockIVoucherRedeemRepository.check(voucherCode: 'voucherCode'))
            .thenAnswer((realInvocation) async => Right(voucherRedeemEntity));

        final result = await voucherRedeemCheckUc(voucherCode: 'voucherCode');

        expect(result, Right(voucherRedeemEntity));
      },
    );

    test(
      'SessionFailure',
      () async {
        when(mockIVoucherRedeemRepository.check())
            .thenAnswer((realInvocation) async => Left(SessionFailure()));

        final result = await voucherRedeemCheckUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<SessionFailure>());
      },
    );

    test(
      'ClientFailure',
      () async {
        when(mockIVoucherRedeemRepository.check()).thenAnswer(
            (realInvocation) async => const Left(MobileValidationFailure()));

        final result = await voucherRedeemCheckUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<MobileValidationFailure>());
      },
    );

    test(
      'ServerFailure',
      () async {
        when(mockIVoucherRedeemRepository.check())
            .thenAnswer((realInvocation) async => const Left(ServerFailure()));

        final result = await voucherRedeemCheckUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<ServerFailure>());
      },
    );

    test(
      'UnknownFailure',
      () async {
        when(mockIVoucherRedeemRepository.check())
            .thenAnswer((realInvocation) async => Left(UnknownFailure()));

        final result = await voucherRedeemCheckUc();

        expect(result, isA<Left>());

        final result2 = result.fold((l) => l, (r) => r);
        expect(result2, isA<UnknownFailure>());
      },
    );
  });
}
