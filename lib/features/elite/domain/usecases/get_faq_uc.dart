import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/faq_entity.dart';
import '../repositories/i_elite_repository.dart';

class GetFaqUc {
  final IEliteRepository repository;

  const GetFaqUc({required this.repository});

  Future<Either<AppFailure, List<FaqEntity>>> call(GetFaqParams params) {
    return repository.getFaq(
      sortBy: params.sortBy,
      orderBy: params.orderBy,
      isActive: params.isActive,
    );
  }
}

class GetFaqParams {
  final String? sortBy;
  final String? orderBy;
  final int? isActive;

  GetFaqParams({this.sortBy, this.orderBy, this.isActive});
}
