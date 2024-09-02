import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/base_resp.dart';
import '../../data/models/verify_otp_forgot_model.dart';

abstract class IForgotPasswordRepository {
  Future<Either<AppFailure, bool>> forgot(
    String newPassword,
    String confirmPassword,
  );

  Future<Either<AppFailure, bool>> sendOtpForgot({
    String? username,
    int? otpType,
    // int? otpLocation,
  });

  Future<Either<AppFailure, BaseResp<VerifyOtpForgotModel>>> verifyOtpForgot({
    String? username,
    String? otpCode,
    int? otpType,
    // int? otpLocation,
  });
}
