import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/get_marketing_option_entity.dart';
import '../repositories/i_elite_repository.dart';

class GetMarketingOptionUc {
  final IEliteRepository repository;

  const GetMarketingOptionUc({required this.repository});

  Future<Either<AppFailure, GetMarketingOptionEntity>> call() {
    return repository.getMarketingOption();
  }
}
