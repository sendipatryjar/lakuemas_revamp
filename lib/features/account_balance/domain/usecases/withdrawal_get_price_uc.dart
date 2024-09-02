import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/price_entity.dart';
import '../repositories/i_account_balance_repository.dart';

class WithdrawalGetPriceUc {
  final IAccountBalanceRepository repository;

  WithdrawalGetPriceUc({required this.repository});

  Future<Either<AppFailure, PriceEntity>> call() => repository.getPrice();
}
