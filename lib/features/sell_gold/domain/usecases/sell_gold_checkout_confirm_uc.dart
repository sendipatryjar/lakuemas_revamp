import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/checkout_confirm_entity.dart';
import '../repositories/i_sell_gold_repository.dart';

class SellGoldCheckoutConfirmUc {
  final ISellGoldRepository repository;

  SellGoldCheckoutConfirmUc({required this.repository});

  Future<Either<AppFailure, CheckoutConfirmEntity>> call({
    String? transactionKey,
  }) =>
      repository.checkoutConfirm(
        transactionKey: transactionKey,
      );
}
