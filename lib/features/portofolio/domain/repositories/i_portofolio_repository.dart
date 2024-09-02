import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../entities/portofolio_entity.dart';
import '../entities/trx_history_entity.dart';

abstract class IPortofolioRepository {
  Future<Either<AppFailure, DataWithMeta<List<TrxHistoryEntity>>>>
      getTrxHistory({
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
    int? status,
    String? type,
    String? period,
    String? startDate,
    String? endDate,
  });
  Future<Either<AppFailure, PortofolioEntity>> getPortofolio();
}
