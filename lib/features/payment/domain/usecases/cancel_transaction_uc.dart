import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_payment_repository.dart';

class CancelTransactionUc {
  final IPaymentRepository repository;

  CancelTransactionUc({required this.repository});

  Future<Either<AppFailure, String?>> call(String? transactionCode) =>
      repository.cancelTransaction(transactionCode: transactionCode);
}
