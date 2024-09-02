import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_kyc_repository.dart';

class GenerateLivenessUrlUc {
  final IKycRepository repository;

  GenerateLivenessUrlUc({required this.repository});

  Future<Either<AppFailure, String?>> call() {
    return repository.generateLivenessUrl();
  }
}
