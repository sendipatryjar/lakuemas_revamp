import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../data/models/lakusave_checkout_req.dart';
import '../repositories/i_lakusave_repoisitory.dart';

class LakusaveCheckoutUc {
  final ILakusaveRepository repository;

  LakusaveCheckoutUc({required this.repository});

  Future<Either<AppFailure, bool>> call(LakusaveChekcoutParams params) =>
      repository.checkout(
        request: params,
      );
}

class LakusaveChekcoutParams extends LakusaveCheckoutReq {
  LakusaveChekcoutParams({
    int? durationId,
    int? extendedId,
    double? goldWeight,
    String? accountNumber,
    String? accountNumberDest,
  }) : super(
          durationId: durationId,
          extendedId: extendedId,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
          accountNumberDest: accountNumberDest,
        );
}
