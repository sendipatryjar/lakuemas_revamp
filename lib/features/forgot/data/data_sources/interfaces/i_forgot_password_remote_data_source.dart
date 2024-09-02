import '../../../../../cores/models/base_resp.dart';
import '../../../../otp/data/models/send_otp_req.dart';
import '../../../../otp/data/models/verify_otp_req.dart';
import '../../models/verify_otp_forgot_model.dart';

abstract class IForgotPasswordRemoteDataSource {
  Future<BaseResp> forgot(
    String? accessToken,
    String? refreshToken,
    String newPassword,
    String confirmPassword,
  );
  Future<BaseResp> sendOtpForgot(SendOtpReq request);
  Future<BaseResp<VerifyOtpForgotModel>> verifyOtpForgot(VerifyOtpReq request);
}
