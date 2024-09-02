import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/detail_offer_entity.dart';
import '../repositories/i_elite_repository.dart';

class GetMyOfferUc {
  final IEliteRepository repository;

  const GetMyOfferUc({required this.repository});

  Future<Either<AppFailure, DetailOfferEntity>> call({int? id}) {
    return repository.getMyDetailOffer(
      id: id,
    );
  }
}
