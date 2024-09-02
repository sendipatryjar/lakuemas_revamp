import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_coupon_repository.dart';

class CouponValidationUc {
  final ICouponRepository repository;

  CouponValidationUc({required this.repository});

  Future<Either<AppFailure, bool?>> call({
    required String couponCode,
    required int amount,
    required int paymentMethodId,
  }) =>
      repository.couponValidation(
        couponCode: couponCode,
        amount: amount,
        paymentMethodId: paymentMethodId,
      );
}
