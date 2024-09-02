import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../repositories/i_beranda_repository.dart';

class BerandaGetBalancesUc {
  final IBerandaRepository repository;

  BerandaGetBalancesUc({required this.repository});

  Future<Either<AppFailure, List<BalanceEntity>>> call() =>
      repository.getBalances();
}
