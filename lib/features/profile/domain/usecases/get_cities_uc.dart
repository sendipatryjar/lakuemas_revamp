import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/city_entity.dart';
import '../repositories/i_address_repository.dart';

class GetCitiesUc {
  final IAddressRepository repository;

  GetCitiesUc({required this.repository});

  Future<Either<AppFailure, List<CityEntity>>> call(GetCitiesParams params) {
    return repository.getCities(
      limit: params.limit,
      page: params.page,
      provinceId: params.provinceId,
      sortBy: params.sortBy,
      orderBy: params.orderBy,
      keyword: params.keyword,
    );
  }
}

class GetCitiesParams {
  final int? limit;
  final int? page;
  final int? provinceId;
  final String? sortBy;
  final String? orderBy;
  final String? keyword;

  GetCitiesParams({
    this.limit,
    this.page,
    this.provinceId,
    this.sortBy,
    this.orderBy,
    this.keyword,
  });
}
