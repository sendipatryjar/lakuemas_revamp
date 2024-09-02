import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_elite_repository.dart';

class UnsubEliteUc {
  final IEliteRepository repository;

  const UnsubEliteUc({required this.repository});

  Future<Either<AppFailure, dynamic>> call({String? reason}) {
    return repository.unsubElite(
      reason: reason,
    );
  }
}
