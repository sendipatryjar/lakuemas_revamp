import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../repositories/i_qr_transfer_repository.dart';

class QRTransferGetBalanceUc {
  final IQRTransferRepository repository;

  QRTransferGetBalanceUc({required this.repository});

  Future<Either<AppFailure, List<BalanceEntity>>> call() =>
      repository.getBalances();
}
