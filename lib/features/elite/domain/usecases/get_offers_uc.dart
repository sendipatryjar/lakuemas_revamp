import 'package:dartz/dartz.dart';
import '../../../../cores/errors/app_failure.dart';
import '../entities/offer_entity.dart';
import '../repositories/i_elite_repository.dart';

class GetOffersUc {
  final IEliteRepository repository;

  const GetOffersUc({required this.repository});

  Future<Either<AppFailure, List<OfferEntity>>> call() {
    return repository.getOffer();
  }
}
