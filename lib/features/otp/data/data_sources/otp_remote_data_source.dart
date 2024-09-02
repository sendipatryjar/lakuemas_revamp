import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/send_otp_req.dart';
import '../models/verify_otp_forgot_model.dart';
import '../models/verify_otp_login_model.dart';
import '../models/verify_otp_register_model.dart';
import '../models/verify_otp_req.dart';
import 'interfaces/i_otp_remote_data_source.dart';

class OtpRemoteDataSource implements IOtpRemoteDataSource {
  final ApiService apiService;

  OtpRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp> sendOtpRegister(SendOtpReq request) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.otpSendRegister,
          request: request.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<VerifyOtpRegisterModel>> verifyOtpRegister(
      VerifyOtpReq request) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.otpVerifyRegister,
          request: request.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, VerifyOtpRegisterModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> sendOtpLogin(SendOtpReq request) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.otpSendLogin,
          request: request.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<VerifyOtpLoginModel>> verifyOtpLogin(
      VerifyOtpReq request) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.otpVerifyLogin,
          request: request.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, VerifyOtpLoginModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> sendOtpVerify(
      {String? accessToken, String? refreshToken, SendOtpReq? request}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: ApiPath.customerVerificationSendOtp,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> verifyOtpVerify({
    String? accessToken,
    String? refreshToken,
    VerifyOtpReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: ApiPath.customerVerificationVerifyOtp,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> sendOtpForgotPin({required SendOtpReq? request}) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.otpSendForgot,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<VerifyOtpForgotModel>> verifyOtpForgotPin(
      {required VerifyOtpReq? request}) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.otpVerifyForgot,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, VerifyOtpForgotModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
