import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/user_favorite_entity.dart';
import '../entities/transfer_charge_entity.dart';
import '../entities/transfer_checkout_entity.dart';

abstract class ITransferRepository {
  Future<Either<AppFailure, TransferChargeEntity>> transferCharge({
    required bool isAddFavorite,
    required double goldWeight,
    required String accountNumber,
    String? note,
  });
  Future<Either<AppFailure, TransferCheckoutEntity>> transferCheckout({
    required String transactionKey,
  });
  Future<Either<AppFailure, List<UserFavoriteEntity>>> userFavorites();
}
