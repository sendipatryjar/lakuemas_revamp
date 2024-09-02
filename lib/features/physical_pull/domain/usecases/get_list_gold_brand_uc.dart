import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/list_gold_brand_entity.dart';
import '../repositories/i_physical_pull_repository.dart';

class GetListGoldBrandUc {
  final IPhysicalPullRepository repository;

  GetListGoldBrandUc({required this.repository});

  Future<Either<AppFailure, List<ListGoldBrandEntity>>> call() =>
      repository.getListGoldBrand();
}
