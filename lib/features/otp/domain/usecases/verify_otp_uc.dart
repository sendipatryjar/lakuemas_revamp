import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_otp_repository.dart';

class VerifyOtpUc {
  final IOtpRepository repo;

  VerifyOtpUc({required this.repo});

  Future<Either<AppFailure, bool?>> call(VerifyOtpParams params) {
    return repo.verifyOtp(
      username: params.username,
      otpCode: params.otpCode,
      otpType: params.otpType,
      privyId: params.privyId,
      otpLocation: params.otpLocation,
    );
  }
}

class VerifyOtpParams {
  String username;
  String otpCode;
  int? otpType;
  String? privyId;

  /// [otpLocation] is between 0 for login and 1 for register
  int otpLocation;

  VerifyOtpParams({
    required this.username,
    required this.otpCode,
    required this.otpType,
    this.privyId,
    required this.otpLocation,
  });
}
