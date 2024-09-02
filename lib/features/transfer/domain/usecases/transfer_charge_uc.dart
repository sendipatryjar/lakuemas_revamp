import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/transfer_charge_entity.dart';
import '../repositories/i_transfer_repository.dart';

class TransferChargeUc {
  final ITransferRepository repository;

  TransferChargeUc({required this.repository});

  Future<Either<AppFailure, TransferChargeEntity>> call({
    required bool isAddFavorite,
    required double goldWeight,
    required String accountNumber,
    String? note,
  }) =>
      repository.transferCharge(
        isAddFavorite: isAddFavorite,
        goldWeight: goldWeight,
        accountNumber: accountNumber,
        note: note,
      );
}
