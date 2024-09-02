import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/coupon_detail_entity.dart';
import '../repositories/i_coupon_repository.dart';

class GetCouponDetailUc {
  final ICouponRepository repository;

  GetCouponDetailUc({required this.repository});

  Future<Either<AppFailure, CouponDetailEntity>> call(
          {required String couponCode}) =>
      repository.getCouponDetail(couponCode: couponCode);
}
