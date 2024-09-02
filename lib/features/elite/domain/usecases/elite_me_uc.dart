import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/elite_me_entity.dart';
import '../repositories/i_elite_repository.dart';

class EliteMeUc {
  final IEliteRepository repository;

  const EliteMeUc({required this.repository});

  Future<Either<AppFailure, EliteMeEntity>> call() {
    return repository.eliteMe();
  }
}
