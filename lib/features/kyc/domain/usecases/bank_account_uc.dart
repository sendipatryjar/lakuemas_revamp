import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_kyc_repository.dart';

class BankAccountUc {
  final IKycRepository repository;

  const BankAccountUc({required this.repository});

  Future<Either<AppFailure, bool>> call(String accountNumber, int bankId) =>
      repository.kycSavings(accountNumber, bankId);
}
