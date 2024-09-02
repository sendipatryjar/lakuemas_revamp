import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/promo_entity.dart';
import '../repositories/i_beranda_repository.dart';

class GetPromosUc {
  final IBerandaRepository repository;

  GetPromosUc({required this.repository});

  Future<Either<AppFailure, List<PromoEntity>>> call() => repository.getPromos(
        limit: 100,
        page: 1,
        orderBy: 'created_at',
        sortBy: 'desc',
        isActive: 1,
      );
}
