import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../repositories/i_sell_gold_repository.dart';

class SellGoldCheckoutUc {
  final ISellGoldRepository repository;

  SellGoldCheckoutUc({required this.repository});

  Future<Either<AppFailure, CheckoutEntity>> call({
    double? amount,
    String? amountType,
  }) =>
      repository.checkout(
        amount: amount,
        amountType: amountType,
      );
}
