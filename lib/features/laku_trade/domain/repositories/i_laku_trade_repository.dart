import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/laku_trade_checkout_entity.dart';
import '../entities/laku_trade_qr_data_entity.dart';

abstract class ILakuTradeRepository {
  Future<Either<AppFailure, LakuTradeQrDataEntity>> getQrData({String? code});
  Future<Either<AppFailure, LakuTradeCheckoutEntity>> checkout({String? code});
}
