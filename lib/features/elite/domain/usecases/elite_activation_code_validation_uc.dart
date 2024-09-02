import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/elite_activation_code_validation_entity.dart';
import '../repositories/i_elite_repository.dart';

class EliteActivationCodeValidationUc {
  final IEliteRepository repository;

  const EliteActivationCodeValidationUc({required this.repository});

  Future<Either<AppFailure, EliteActivationCodeValidationEntity>> call(
    dynamic voucherCode,
    String? type,
  ) {
    return repository.eliteActivationCodeValidation(
      voucherCode: voucherCode,
      type: type,
    );
  }
}
