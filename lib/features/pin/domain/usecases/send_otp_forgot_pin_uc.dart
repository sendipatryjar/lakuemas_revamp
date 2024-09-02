// import 'package:dartz/dartz.dart';

// import '../../../../cores/errors/app_failure.dart';
// import '../repositories/i_pin_repository.dart';

// class SendOtpForgotPinUc {
//   final IPinRepository repository;

//   SendOtpForgotPinUc({required this.repository});

//   Future<Either<AppFailure, bool>> call(SendOtpPinParams params) {
//     return repository.sendOtpForgot(
//       username: params.username,
//       otpType: params.otpType,
//     );
//   }
// }

// class SendOtpPinParams {
//   String username;
//   int otpType;

//   SendOtpPinParams({
//     required this.username,
//     required this.otpType,
//   });
// }
