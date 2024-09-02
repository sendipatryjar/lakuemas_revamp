import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/get_banks_entity.dart';

abstract class IGetBanksRepository {
  Future<Either<AppFailure, List<GetBanksEntity>>> bankAccount({
    int? limit,
    int? page,
    String? sortBy,
  });
}
