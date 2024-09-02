import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/price_entity.dart';
import '../repositories/i_beranda_repository.dart';

class GetPriceSettingUc {
  final IBerandaRepository repository;

  GetPriceSettingUc({required this.repository});

  Future<Either<AppFailure, PriceEntity>> call() =>
      repository.getPriceSetting();
}
