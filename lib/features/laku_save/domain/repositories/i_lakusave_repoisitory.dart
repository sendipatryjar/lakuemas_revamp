import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../data/models/get_transactions_req.dart';
import '../../data/models/lakusave_checkout_req.dart';
import '../entities/gold_deposit_entity.dart';
import '../entities/transaction_entity.dart';

abstract class ILakusaveRepository {
  Future<Either<AppFailure, GoldDepositEntity>> getMasterData();
  Future<Either<AppFailure, bool>> checkout({
    required LakusaveCheckoutReq request,
  });
  Future<Either<AppFailure, bool>> cancel({String? transactionCode});
  Future<Either<AppFailure, List<TransactionEntity>>> getTransactions({
    required GetTransactionsReq request,
  });
  Future<Either<AppFailure, bool>> updateExtend({
    int? extendId,
    String? accountNumber,
  });
  Future<Either<AppFailure, String?>> getAbout();
}
