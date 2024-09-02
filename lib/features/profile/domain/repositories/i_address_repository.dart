import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/city_entity.dart';
import '../entities/country_entity.dart';
import '../entities/detail_district_entity.dart';
import '../entities/district_entity.dart';
import '../entities/province_entity.dart';

abstract class IAddressRepository {
  Future<Either<AppFailure, List<CountryEntity>>> getCountries({
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
  });
  Future<Either<AppFailure, List<ProvinceEntity>>> getProvinces({
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
  });
  Future<Either<AppFailure, List<CityEntity>>> getCities({
    int? limit,
    int? page,
    int? provinceId,
    String? sortBy,
    String? orderBy,
    String? keyword,
  });
  Future<Either<AppFailure, List<DistrictEntity>>> getDistricts({
    int? limit,
    int? page,
    int? cityId,
    String? sortBy,
    String? orderBy,
  });
  Future<Either<AppFailure, DetailDistrictEntity>> getDetailDistrict({
    int? id,
  });
}
