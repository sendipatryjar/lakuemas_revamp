import '../../../../features/forgot/data/models/verify_otp_forgot_model.dart';
import '../../../../features/otp/data/models/send_otp_req.dart';
import '../../../../features/otp/data/models/verify_otp_req.dart';
import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import 'interfaces/i_forgot_password_remote_data_source.dart';

class ForgotPasswordRemoteDataSource
    implements IForgotPasswordRemoteDataSource {
  final ApiService apiService;

  ForgotPasswordRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp> forgot(
    String? accessToken,
    String? refreshToken,
    String newPassword,
    String confirmPassword,
  ) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.forgotPassword,
      request: {
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> sendOtpForgot(SendOtpReq request) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.otpSendForgot,
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
  Future<BaseResp<VerifyOtpForgotModel>> verifyOtpForgot(
    VerifyOtpReq request,
  ) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.otpVerifyForgot,
          request: request.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, VerifyOtpForgotModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
