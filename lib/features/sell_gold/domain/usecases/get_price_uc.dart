import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/price_entity.dart';
import '../repositories/i_sell_gold_repository.dart';

class GetPriceUc {
  final ISellGoldRepository repository;

  GetPriceUc({required this.repository});

  Future<Either<AppFailure, PriceEntity>> call() => repository.getPrice();
}
