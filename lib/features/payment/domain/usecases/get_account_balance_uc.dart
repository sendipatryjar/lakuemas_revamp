import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../repositories/i_payment_repository.dart';

class GetAccountBalanceUc {
  final IPaymentRepository repository;

  GetAccountBalanceUc({required this.repository});

  Future<Either<AppFailure, BalanceEntity>> call() =>
      repository.getAccountBalance();
}
