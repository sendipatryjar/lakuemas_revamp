import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../entities/elite_me_entity.dart';
import '../repositories/i_elite_repository.dart';

class GetListReferralUc {
  final IEliteRepository repository;

  const GetListReferralUc({required this.repository});

  Future<Either<AppFailure, DataWithMeta<List<ListReferralEntity>>>> call({
    int? limit,
    int? page,
    String? startDate,
    String? endDate,
    String? startValidDate,
    String? endValidDate,
  }) {
    return repository.getListReferral(
      limit: limit ?? 10,
      page: page ?? 1,
      startDate: startDate,
      endDate: endDate,
      startValidDate: startValidDate,
      endValidDate: endValidDate,
    );
  }
}
