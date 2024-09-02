import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/bank_me_entity.dart';
import '../repositories/i_account_balance_repository.dart';

class GetBankMeUc {
  final IAccountBalanceRepository repository;

  GetBankMeUc({required this.repository});

  Future<Either<AppFailure, BankMeEntity>> call() => repository.getBankMe();
}
