import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/account_balance_faq_entity.dart';
import '../repositories/i_account_balance_repository.dart';

class GetFaqUc {
  final IAccountBalanceRepository repository;

  GetFaqUc({required this.repository});

  Future<Either<AppFailure, List<AccountBalanceFaqEntity>>> call() =>
      repository.getFaq();
}
