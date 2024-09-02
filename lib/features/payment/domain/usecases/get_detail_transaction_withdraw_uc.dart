import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/detail_transaction_entity.dart';
import '../repositories/i_payment_repository.dart';

class GetDetailTransactionWithdrawUc {
  final IPaymentRepository repository;

  GetDetailTransactionWithdrawUc({required this.repository});

  Future<Either<AppFailure, DetailTransactionEntity>> call(
          String transactionCode) =>
      repository.getDetailTransactionWithdraw(transactionCode: transactionCode);
}
