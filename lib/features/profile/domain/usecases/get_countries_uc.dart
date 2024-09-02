import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/country_entity.dart';
import '../repositories/i_address_repository.dart';

class GetCountriesUc {
  final IAddressRepository repository;

  GetCountriesUc({required this.repository});

  Future<Either<AppFailure, List<CountryEntity>>> call(
      GetCountriesParams params) {
    return repository.getCountries(
      limit: params.limit,
      page: params.page,
      sortBy: params.sortBy,
      orderBy: params.orderBy,
    );
  }
}

class GetCountriesParams {
  final int? limit;
  final int? page;
  final String? sortBy;
  final String? orderBy;

  GetCountriesParams({
    this.limit,
    this.page,
    this.sortBy,
    this.orderBy,
  });
}
