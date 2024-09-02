import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/promo_entity.dart';
import '../repositories/i_beranda_repository.dart';

class GetPromoByIdUc {
  final IBerandaRepository repository;

  GetPromoByIdUc({required this.repository});

  Future<Either<AppFailure, PromoEntity>> call({int? id}) =>
      repository.getPromoById(id: id);
}
