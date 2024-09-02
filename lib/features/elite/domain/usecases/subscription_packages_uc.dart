import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/subscription_packages_entity.dart';
import '../repositories/i_elite_repository.dart';

class SubscriptionPackagesUc {
  final IEliteRepository repository;

  const SubscriptionPackagesUc({required this.repository});

  Future<Either<AppFailure, List<SubscriptionPackagesEntity>>> call() {
    return repository.getSubscriptionPackages();
  }
}
