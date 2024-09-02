import '../../../../../cores/models/base_resp.dart';
import '../../models/send_otp_req.dart';
import '../../models/verify_otp_forgot_model.dart';
import '../../models/verify_otp_login_model.dart';
import '../../models/verify_otp_register_model.dart';
import '../../models/verify_otp_req.dart';

abstract class IOtpRemoteDataSource {
  Future<BaseResp> sendOtpRegister(SendOtpReq request);
  Future<BaseResp<VerifyOtpRegisterModel>> verifyOtpRegister(
      VerifyOtpReq request);
  //
  Future<BaseResp> sendOtpLogin(SendOtpReq request);
  Future<BaseResp<VerifyOtpLoginModel>> verifyOtpLogin(VerifyOtpReq request);
  //
  Future<BaseResp> sendOtpVerify(
      {String? accessToken, String? refreshToken, SendOtpReq? request});
  Future<BaseResp> verifyOtpVerify({
    String? accessToken,
    String? refreshToken,
    VerifyOtpReq? request,
  });
  //
  Future<BaseResp> sendOtpForgotPin({required SendOtpReq? request});
  Future<BaseResp<VerifyOtpForgotModel>> verifyOtpForgotPin(
      {required VerifyOtpReq? request});
}
