import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/voucher_redeem_entity.dart';
import '../repositories/i_voucher_redeem_repository.dart';

class VoucherRedeemCheckUc {
  final IVoucherRedeemRepository repository;

  VoucherRedeemCheckUc({required this.repository});

  Future<Either<AppFailure, VoucherRedeemEntity?>> call(
          {String? voucherCode}) =>
      repository.check(voucherCode: voucherCode);
}
