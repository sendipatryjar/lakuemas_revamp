import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/province_entity.dart';
import '../repositories/i_address_repository.dart';

class GetProvincesUc {
  final IAddressRepository repository;

  GetProvincesUc({required this.repository});

  Future<Either<AppFailure, List<ProvinceEntity>>> call(
      GetProvincesParams params) {
    return repository.getProvinces(
      limit: params.limit,
      page: params.page,
      sortBy: params.sortBy,
      orderBy: params.orderBy,
    );
  }
}

class GetProvincesParams {
  final int? limit;
  final int? page;
  final String? sortBy;
  final String? orderBy;

  GetProvincesParams({this.limit, this.page, this.sortBy, this.orderBy});
}
