import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/voucher_referral_entity.dart';
import '../repositories/i_elite_repository.dart';

class GetVoucherReferralUc {
  final IEliteRepository repository;

  const GetVoucherReferralUc({required this.repository});

  Future<Either<AppFailure, List<VoucherReferralEntity>>> call() {
    return repository.getVoucherReferral();
  }
}
