import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../repositories/i_buy_gold_repository.dart';

class GetBalancesUc {
  final IBuyGoldRepository repository;

  GetBalancesUc({required this.repository});

  Future<Either<AppFailure, List<BalanceEntity>>> call() =>
      repository.getBalances();
}
