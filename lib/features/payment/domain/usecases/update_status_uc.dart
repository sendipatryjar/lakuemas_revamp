import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/update_status_entity.dart';
import '../repositories/i_payment_repository.dart';

class UpdateStatusUc {
  final IPaymentRepository repository;

  UpdateStatusUc({required this.repository});

  Future<Either<AppFailure, UpdateStatusEntity>> call(String transactionCode) =>
      repository.updateStatus(transactionCode: transactionCode);
}
