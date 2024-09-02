import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/coupon_entity.dart';
import '../repositories/i_coupon_repository.dart';

class GetCouponsUc {
  final ICouponRepository repository;

  GetCouponsUc({required this.repository});

  Future<Either<AppFailure, List<CouponEntity>>> call() =>
      repository.getCoupons();
}
