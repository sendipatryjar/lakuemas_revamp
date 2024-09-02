import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/mutation_entity.dart';
import '../repositories/i_account_balance_repository.dart';

class GetMutationsUc {
  final IAccountBalanceRepository repository;

  GetMutationsUc({required this.repository});

  Future<Either<AppFailure, List<MutationEntity>>> call({
    int? status,
    String? period,
    String? startDate,
    String? endDate,
  }) =>
      repository.getMutations(
        status: status,
        period: period,
        startDate: startDate,
        endDate: endDate,
      );
}
