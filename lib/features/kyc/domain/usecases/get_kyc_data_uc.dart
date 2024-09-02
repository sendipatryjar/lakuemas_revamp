import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/kyc_entity.dart';
import '../repositories/i_kyc_repository.dart';

class GetKycDataUc {
  final IKycRepository repository;

  GetKycDataUc({required this.repository});

  Future<Either<AppFailure, KycEntity>> call({bool isCallApi = false}) =>
      repository.getKycData(isCallApi: isCallApi);
}
