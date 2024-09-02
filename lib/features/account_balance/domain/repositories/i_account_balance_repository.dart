import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/price_entity.dart';
import '../entities/account_balance_faq_entity.dart';
import '../entities/bank_me_entity.dart';
import '../entities/mutation_entity.dart';
import '../entities/withdrawal_entity.dart';

abstract class IAccountBalanceRepository {
  Future<Either<AppFailure, List<MutationEntity>>> getMutations({
    int? status,
    String? period,
    String? startDate,
    String? endDate,
  });
  Future<Either<AppFailure, List<AccountBalanceFaqEntity>>> getFaq();
  Future<Either<AppFailure, PriceEntity>> getPrice();
  Future<Either<AppFailure, BankMeEntity>> getBankMe();
  Future<Either<AppFailure, WithdrawalEntity>> withdraw({
    int? amount,
  });
}
