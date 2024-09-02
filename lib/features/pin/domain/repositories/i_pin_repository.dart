import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/pin_entity.dart';

abstract class IPinRepository {
  Future<Either<AppFailure, bool>> createPin({String? pin, String? pinConfirm});
  Future<Either<AppFailure, PinEntity?>> validatePin({
    String? pin,
    String? firebaseToken,
  });
  Future<Either<AppFailure, bool>> forgotPin(
    String newPin,
    String confirmPin,
  );

  // Future<Either<AppFailure, bool>> sendOtpForgot({
  //   String? username,
  //   int? otpType,
  // });

  // Future<Either<AppFailure, BaseResp<VerifyOtpForgotModel>>> verifyOtpForgot({
  //   String? username,
  //   String? otpCode,
  //   int? otpType,
  // });
}
