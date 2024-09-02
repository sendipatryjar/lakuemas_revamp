import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/detail_transaction_entity.dart';
import '../repositories/i_payment_repository.dart';

class GetDetailTransactionEliteUc {
  final IPaymentRepository repository;

  GetDetailTransactionEliteUc({required this.repository});

  Future<Either<AppFailure, DetailTransactionEntity>> call(String code) =>
      repository.getDetailTransactionElite(code: code);
}
