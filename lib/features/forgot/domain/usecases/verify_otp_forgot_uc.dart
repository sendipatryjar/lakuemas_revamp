import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/base_resp.dart';
import '../../data/models/verify_otp_forgot_model.dart';
import '../repositories/i_forgot_password_repository.dart';

class VerifyOtpForgotUc {
  final IForgotPasswordRepository repository;

  VerifyOtpForgotUc({required this.repository});

  Future<Either<AppFailure, BaseResp<VerifyOtpForgotModel>>> call(
      VerifyOtpParams params) {
    return repository.verifyOtpForgot(
      username: params.username,
      otpCode: params.otpCode,
      otpType: params.otpType,
    );
  }
}

class VerifyOtpParams {
  String username;
  String otpCode;
  int? otpType;

  VerifyOtpParams({
    required this.username,
    required this.otpCode,
    required this.otpType,
  });
}
