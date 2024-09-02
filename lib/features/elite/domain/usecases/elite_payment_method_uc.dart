import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_elite_repository.dart';

class ElitePaymentMethodUc {
  final IEliteRepository repository;

  const ElitePaymentMethodUc({required this.repository});

  Future<Either<AppFailure, dynamic>> call() {
    return repository.elitePaymentMethod();
  }
}
