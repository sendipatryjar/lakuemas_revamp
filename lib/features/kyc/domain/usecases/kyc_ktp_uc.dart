import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_kyc_repository.dart';

class KycKtpUc {
  final IKycRepository repository;

  KycKtpUc({required this.repository});

  Future<Either<AppFailure, bool>> call(KycKtpParams params) =>
      repository.kycKtp(
        nik: params.nik,
        name: params.name,
        pob: params.pob,
        dob: params.dob,
        ktpPhotoBytes: params.ktpPhotoBytes,
      );
}

class KycKtpParams {
  final String? nik;
  final String? name;
  final String? pob;
  final String? dob;
  final List<int>? ktpPhotoBytes;
  KycKtpParams({this.nik, this.name, this.pob, this.dob, this.ktpPhotoBytes});
}
