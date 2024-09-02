import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../repositories/i_sell_gold_repository.dart';

class GetBalancesUc {
  final ISellGoldRepository repository;

  GetBalancesUc({required this.repository});

  Future<Either<AppFailure, List<BalanceEntity>>> call() =>
      repository.getBalances();
}
