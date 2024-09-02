import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../../_core/transaction/domain/entities/price_entity.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../entities/checkout_confirm_entity.dart';

abstract class ISellGoldRepository {
  Future<Either<AppFailure, List<BalanceEntity>>> getBalances();
  Future<Either<AppFailure, PriceEntity>> getPrice();
  Future<Either<AppFailure, CheckoutEntity>> checkout({
    double? amount,

    /// [amountType] is between nominal or grammation
    String? amountType,
  });
  Future<Either<AppFailure, CheckoutConfirmEntity>> checkoutConfirm({
    String? transactionKey,
  });
}
