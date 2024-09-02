import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/elite_referal_validation_entity.dart';
import '../repositories/i_elite_repository.dart';

class EliteReferalValidationUc {
  final IEliteRepository repository;

  const EliteReferalValidationUc({required this.repository});

  Future<Either<AppFailure, EliteReferalValidaitonEntity>> call(
      dynamic referalCode) {
    return repository.eliteReferalValidaiton(
      referalCode: referalCode,
    );
  }
}
