import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_elite_repository.dart';

class EliteStartRegisterUc {
  final IEliteRepository repository;

  const EliteStartRegisterUc({required this.repository});

  Future<Either<AppFailure, dynamic>> call() {
    return repository.eliteStartRegister();
  }
}
