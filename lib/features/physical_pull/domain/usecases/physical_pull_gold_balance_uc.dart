import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../repositories/i_physical_pull_repository.dart';

class PhysicalPullGoldBalanceUc {
  final IPhysicalPullRepository repository;

  PhysicalPullGoldBalanceUc({required this.repository});

  Future<Either<AppFailure, List<BalanceEntity>>> call() =>
      repository.getBalances();
}
