import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/detail_district_entity.dart';
import '../repositories/i_address_repository.dart';

class GetDetailDistrictUc {
  final IAddressRepository repository;

  GetDetailDistrictUc({required this.repository});

  Future<Either<AppFailure, DetailDistrictEntity>> call({int? id}) {
    return repository.getDetailDistrict(
      id: id,
    );
  }
}
