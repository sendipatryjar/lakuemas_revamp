import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_forgot_password_repository.dart';

class SendOtpForgotUc {
  final IForgotPasswordRepository repository;

  SendOtpForgotUc({required this.repository});

  Future<Either<AppFailure, bool>> call(SendOtpParams params) {
    return repository.sendOtpForgot(
      username: params.username,
      otpType: params.otpType,
    );
  }
}

class SendOtpParams {
  String username;
  int otpType;

  SendOtpParams({
    required this.username,
    required this.otpType,
  });
}
