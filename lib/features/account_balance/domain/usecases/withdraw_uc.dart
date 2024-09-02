import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/withdrawal_entity.dart';
import '../repositories/i_account_balance_repository.dart';

class WithdrawUc {
  final IAccountBalanceRepository repository;

  WithdrawUc({required this.repository});

  Future<Either<AppFailure, WithdrawalEntity>> call({int? amount}) =>
      repository.withdraw(amount: amount);
}
