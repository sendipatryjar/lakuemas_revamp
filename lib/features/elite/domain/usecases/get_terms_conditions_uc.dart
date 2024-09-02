import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_elite_repository.dart';

class GetTermsConditionsUc {
  final IEliteRepository repository;

  const GetTermsConditionsUc({required this.repository});

  Future<Either<AppFailure, String>> call() {
    return repository.getTermsConditions();
  }
}
