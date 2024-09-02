import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../../data/models/physical_pull_checkout_req.dart';
import '../entities/list_gold_brand_entity.dart';
import '../entities/physical_pull_checkout_entity.dart';
import '../entities/store_entity.dart';

abstract class IPhysicalPullRepository {
  Future<Either<AppFailure, List<BalanceEntity>>> getBalances();
  Future<Either<AppFailure, List<ListGoldBrandEntity>>> getListGoldBrand();
  Future<Either<AppFailure, List<StoreEntity>>> getStore({
    int? limit,
    int? page,
    int? cityId,
    String? sortBy,
    String? orderBy,
  });
  Future<Either<AppFailure, CheckoutEntity>> charge({
    List<Map<String, dynamic>>? listPhysicalPullReq,
  });
  Future<Either<AppFailure, PhysicalPullCheckoutEntity>> physicalPullCheckout({
    PhysicalPullCheckoutReq? physicalPullCheckoutReq,
  });
}
