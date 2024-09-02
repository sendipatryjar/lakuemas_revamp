import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/elite_register_entity.dart';
import '../repositories/i_elite_repository.dart';

class EliteConfirmRegisterUc {
  final IEliteRepository repository;

  const EliteConfirmRegisterUc({required this.repository});

  Future<Either<AppFailure, EliteRegisterEntity>> call(int? customerId) {
    return repository.eliteConfirmRegister(
      customerId: customerId,
    );
  }
}
