import 'package:dartz/dartz.dart';
import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../entities/gold_income_entity.dart';

abstract class IGoldDetailsRepository {
  Future<Either<AppFailure, List<BalanceEntity>>> getBalances();
  Future<Either<AppFailure, GoldIncomeEntity>> getGoldIncome();
}
