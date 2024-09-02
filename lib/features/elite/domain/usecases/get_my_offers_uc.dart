import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/offer_entity.dart';
import '../repositories/i_elite_repository.dart';

class GetMyOffersUc {
  final IEliteRepository repository;

  const GetMyOffersUc({required this.repository});

  Future<Either<AppFailure, List<OfferEntity>>> call() {
    return repository.getMyOffer();
  }
}
