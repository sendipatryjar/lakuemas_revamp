import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../respositories/i_gold_details_repository.dart';

class GetGoldDetailsBalanceUc {
  final IGoldDetailsRepository repository;

  GetGoldDetailsBalanceUc({required this.repository});

  Future<Either<AppFailure, List<BalanceEntity>>> call() =>
      repository.getBalances();
}
