import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_kyc_repository.dart';

class NpwpVerificationUc {
  final IKycRepository repository;

  NpwpVerificationUc({required this.repository});

  Future<Either<AppFailure, bool>> call(String npwpNo, String npwpPhotoBytes) =>
      repository.kycNpwp(
        npwpNo,
        npwpPhotoBytes,
      );
}
