import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/store_entity.dart';
import '../repositories/i_physical_pull_repository.dart';

class GetStoreUc {
  final IPhysicalPullRepository repository;

  GetStoreUc({required this.repository});

  Future<Either<AppFailure, List<StoreEntity>>> call(GetStoreParams params) =>
      repository.getStore(
        limit: params.limit,
        page: params.page,
        cityId: params.cityId,
        sortBy: params.sortBy,
        orderBy: params.orderBy,
      );
}

class GetStoreParams {
  final int? limit;
  final int? page;
  final int? cityId;
  final String? sortBy;
  final String? orderBy;

  GetStoreParams({
    this.limit,
    this.page,
    this.cityId,
    this.sortBy,
    this.orderBy,
  });
}
