import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_elite_repository.dart';

class RedeemOfferUc {
  final IEliteRepository repository;

  const RedeemOfferUc({required this.repository});

  Future<Either<AppFailure, Map<String, dynamic>>> call({int? id}) {
    return repository.redeemOffer(
      id: id,
    );
  }
}
