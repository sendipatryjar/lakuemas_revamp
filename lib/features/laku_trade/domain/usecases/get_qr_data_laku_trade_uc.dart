import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/laku_trade_qr_data_entity.dart';
import '../repositories/i_laku_trade_repository.dart';

class GetQrDataLakuTradeUc {
  final ILakuTradeRepository repository;

  GetQrDataLakuTradeUc({required this.repository});

  Future<Either<AppFailure, LakuTradeQrDataEntity>> call({String? code}) =>
      repository.getQrData(code: code);
}
