import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../repositories/i_physical_pull_repository.dart';

class ChargeUc {
  final IPhysicalPullRepository repository;

  const ChargeUc({required this.repository});

  Future<Either<AppFailure, CheckoutEntity>> call(ChargeParams params) =>
      repository.charge(
        listPhysicalPullReq: params.listPhysicalPullReq,
      );
}

class ChargeParams {
  final List<Map<String, dynamic>>? listPhysicalPullReq;

  ChargeParams({this.listPhysicalPullReq});
}
