import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/laku_trade_checkout_entity.dart';
import '../repositories/i_laku_trade_repository.dart';

class LakuTradeCheckoutUc {
  final ILakuTradeRepository repository;

  LakuTradeCheckoutUc({required this.repository});

  Future<Either<AppFailure, LakuTradeCheckoutEntity>> call({String? code}) =>
      repository.checkout(code: code);
}
