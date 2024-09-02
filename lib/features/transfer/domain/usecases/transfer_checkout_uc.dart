import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/transfer_checkout_entity.dart';
import '../repositories/i_transfer_repository.dart';

class TransferCheckoutUc {
  final ITransferRepository repository;

  TransferCheckoutUc({required this.repository});

  Future<Either<AppFailure, TransferCheckoutEntity?>> call(
          {required String transactionKey}) =>
      repository.transferCheckout(
        transactionKey: transactionKey,
      );
}
