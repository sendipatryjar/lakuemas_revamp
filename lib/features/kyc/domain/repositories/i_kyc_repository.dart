import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/kyc_entity.dart';

abstract class IKycRepository {
  Future<Either<AppFailure, KycEntity>> getKycData({bool isCallApi = false});
  Future<Either<AppFailure, bool>> kycKtp({
    String? nik,
    String? name,
    String? pob,
    String? dob,
    List<int>? ktpPhotoBytes,
  });
  Future<Either<AppFailure, bool>> kycSelfie({
    List<int>? selfiePhotoBytes,
  });
  Future<Either<AppFailure, bool>> kycNpwp(
    String npwpNo,
    String npwpPhotoBytes,
  );
  Future<Either<AppFailure, bool>> kycSavings(
    String accountNumber,
    int bankId,
  );
  Future<Either<AppFailure, String?>> generateLivenessUrl();
}
