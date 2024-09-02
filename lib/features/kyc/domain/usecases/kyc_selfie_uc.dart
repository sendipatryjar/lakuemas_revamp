import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_kyc_repository.dart';

class KycSelfieUc {
  final IKycRepository repository;

  KycSelfieUc({required this.repository});

  Future<Either<AppFailure, bool>> call(List<int>? params) =>
      repository.kycSelfie(
        selfiePhotoBytes: params,
      );
}
