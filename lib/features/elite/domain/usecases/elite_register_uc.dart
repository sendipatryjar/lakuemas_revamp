import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/elite_register_entity.dart';
import '../repositories/i_elite_repository.dart';

class EliteRegisterUc {
  final IEliteRepository repository;

  const EliteRegisterUc({required this.repository});

  Future<Either<AppFailure, EliteRegisterEntity>> call(
      EliteRegisterParams params) {
    return repository.eliteRegister(
      customerId: params.customerId,
      packageId: params.packageId,
      paymentMethodId: params.paymentMethodId,
      voucherId: params.voucherId,
      autoRenewalPaymentMethod: params.autoRenewalPaymentMethod,
      referalCode: params.referalCode,
    );
  }
}

class EliteRegisterParams {
  final int? customerId;
  final int? packageId;
  final int? paymentMethodId;
  final String? voucherId;
  final String? autoRenewalPaymentMethod;
  final String? referalCode;

  EliteRegisterParams({
    this.customerId,
    this.packageId,
    this.paymentMethodId,
    this.voucherId,
    this.autoRenewalPaymentMethod,
    this.referalCode,
  });
}
