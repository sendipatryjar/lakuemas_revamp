import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/voucher_redeemed_entity.dart';
import '../repositories/i_voucher_redeem_repository.dart';

class VoucherRedeemUc {
  final IVoucherRedeemRepository repository;

  VoucherRedeemUc({required this.repository});

  Future<Either<AppFailure, VoucherRedeemedEntity?>> call({
    String? voucherCode,
    double? goldRedeemed,
  }) =>
      repository.redeem(
        voucherCode: voucherCode,
        goldRedeemed: goldRedeemed,
      );
}
