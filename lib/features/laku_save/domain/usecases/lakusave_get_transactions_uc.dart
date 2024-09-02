import 'package:dartz/dartz.dart';

import '../../../../features/laku_save/data/models/get_transactions_req.dart';
import '../../../../cores/errors/app_failure.dart';
import '../entities/transaction_entity.dart';
import '../repositories/i_lakusave_repoisitory.dart';

class LakusaveGetTransactionsUc {
  final ILakusaveRepository repository;

  LakusaveGetTransactionsUc({required this.repository});

  Future<Either<AppFailure, List<TransactionEntity>>> call(
          {required GetTransactionsParams params}) =>
      repository.getTransactions(request: params);
}

class GetTransactionsParams extends GetTransactionsReq {
  GetTransactionsParams({
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
    int? status,
    String? type,
  }) : super(
          limit: limit,
          page: page,
          sortBy: sortBy,
          orderBy: orderBy,
          status: status,
          type: type,
        );
}
