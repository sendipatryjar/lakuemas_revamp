import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';

abstract class IOtpRepository {
  /// [otpLocation] is between 0 for login, 1 for register, 2 for verify
  Future<Either<AppFailure, bool>> sendOtp(
      {String? username, int? otpType, int? otpLocation});

  /// [otpLocation] is between 0 for login, 1 for register, 2 for verify
  Future<Either<AppFailure, bool?>> verifyOtp({
    String? username,
    String? otpCode,
    int? otpLocation,
    int? otpType,
    String? privyId,
  });
}
