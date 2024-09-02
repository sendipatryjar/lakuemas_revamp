import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/coupon_detail_entity.dart';
import '../entities/coupon_entity.dart';

abstract class ICouponRepository {
  Future<Either<AppFailure, List<CouponEntity>>> getCoupons();
  Future<Either<AppFailure, CouponDetailEntity>> getCouponDetail({
    required String couponCode,
  });
  Future<Either<AppFailure, bool?>> couponValidation({
    required String couponCode,
    required int amount,
    required int paymentMethodId,
  });
}
