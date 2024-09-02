import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/district_entity.dart';
import '../repositories/i_address_repository.dart';

class GetDistrictsUc {
  final IAddressRepository repository;

  GetDistrictsUc({required this.repository});

  Future<Either<AppFailure, List<DistrictEntity>>> call(
      GetDistrictsParams params) {
    return repository.getDistricts(
      limit: params.limit,
      page: params.page,
      cityId: params.cityId,
      sortBy: params.sortBy,
      orderBy: params.orderBy,
    );
  }
}

class GetDistrictsParams {
  final int? limit;
  final int? page;
  final int? cityId;
  final String? sortBy;
  final String? orderBy;

  GetDistrictsParams(
      {this.limit, this.page, this.cityId, this.sortBy, this.orderBy});
}
