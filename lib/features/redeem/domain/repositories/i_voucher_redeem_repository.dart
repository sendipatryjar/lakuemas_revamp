import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/voucher_redeem_entity.dart';
import '../entities/voucher_redeemed_entity.dart';

abstract class IVoucherRedeemRepository {
  Future<Either<AppFailure, VoucherRedeemEntity?>> check({String? voucherCode});
  Future<Either<AppFailure, VoucherRedeemedEntity?>> redeem({
    String? voucherCode,
    double? goldRedeemed,
  });
}
