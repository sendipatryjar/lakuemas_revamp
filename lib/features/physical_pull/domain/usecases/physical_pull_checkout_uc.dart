import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../data/models/physical_pull_checkout_req.dart';
import '../entities/physical_pull_checkout_entity.dart';
import '../repositories/i_physical_pull_repository.dart';

class PhysicalPullCheckoutUc {
  final IPhysicalPullRepository repository;

  const PhysicalPullCheckoutUc({required this.repository});

  Future<Either<AppFailure, PhysicalPullCheckoutEntity>> call(
          PhysicalPullCheckoutParams params) =>
      repository.physicalPullCheckout(
        physicalPullCheckoutReq: params.physicalPullCheckoutReq,
      );
}

class PhysicalPullCheckoutParams {
  final PhysicalPullCheckoutReq? physicalPullCheckoutReq;

  PhysicalPullCheckoutParams({this.physicalPullCheckoutReq});
}
