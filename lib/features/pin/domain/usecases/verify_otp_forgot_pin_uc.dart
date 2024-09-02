// import 'package:dartz/dartz.dart';

// import '../../../../cores/errors/app_failure.dart';
// import '../../../../cores/models/base_resp.dart';
// import '../../../forgot/data/models/verify_otp_forgot_model.dart';
// import '../repositories/i_pin_repository.dart';

// class VerifyOtpForgotPinUc {
//   final IPinRepository repository;

//   VerifyOtpForgotPinUc({required this.repository});

//   Future<Either<AppFailure, BaseResp<VerifyOtpForgotModel>>> call(
//       VerifyOtpParams params) {
//     return repository.verifyOtpForgot(
//       username: params.username,
//       otpCode: params.otpCode,
//       otpType: params.otpType,
//     );
//   }
// }

// class VerifyOtpParams {
//   String username;
//   String otpCode;
//   int? otpType;

//   VerifyOtpParams({
//     required this.username,
//     required this.otpCode,
//     required this.otpType,
//   });
// }
