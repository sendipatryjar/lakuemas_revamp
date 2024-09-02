import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_otp_repository.dart';

class SendOtpUc {
  final IOtpRepository repo;

  SendOtpUc({required this.repo});

  Future<Either<AppFailure, bool>> call(SendOtpParams params) {
    return repo.sendOtp(
      username: params.username,
      otpType: params.otpType,
      otpLocation: params.otpLocation,
    );
  }
}

class SendOtpParams {
  String username;
  int otpType;

  /// [otpLocation] is between 0 for login and 1 for register
  int otpLocation;

  SendOtpParams({
    required this.username,
    required this.otpType,
    required this.otpLocation,
  });
}
