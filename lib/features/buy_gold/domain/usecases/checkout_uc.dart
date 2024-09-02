import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../repositories/i_buy_gold_repository.dart';

class CheckoutUc {
  final IBuyGoldRepository repository;

  CheckoutUc({required this.repository});

  Future<Either<AppFailure, CheckoutEntity>> call({
    double? amount,
    String? amountType,
  }) =>
      repository.checkout(
        amount: amount,
        amountType: amountType,
      );
}
