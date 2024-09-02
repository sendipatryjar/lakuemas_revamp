import 'package:dartz/dartz.dart';
import '../../../../cores/models/data_with_meta.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/elite_history_entity.dart';
import '../repositories/i_elite_repository.dart';

class EliteHistoryUc {
  final IEliteRepository repository;

  const EliteHistoryUc({required this.repository});

  Future<Either<AppFailure, DataWithMeta<List<EliteHistoryEntity>>>> call({
    int? limit,
    int? page,
    String? startDate,
    String? endDate,
    String? orderBy,
    String? sortBy,
    int? statuses,
    String? period,
  }) {
    return repository.eliteHistory(
      limit: limit ?? 10,
      page: page ?? 1,
      orderBy: orderBy ?? 'created_at',
      sortBy: sortBy ?? 'desc',
      startDate: startDate,
      endDate: endDate,
      statuses: statuses,
      period: period,
    );
  }
}
