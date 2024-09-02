import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/pin_model.dart';
import 'interfaces/i_pin_remote_data_source.dart';

class PinRemoteDataSource implements IPinRemoteDataSource {
  final ApiService apiService;

  PinRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp> createPin({
    String? pin,
    String? pinConfirmation,
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.pin,
      request: {
        'pin': pin,
        'confirm_pin': pinConfirmation,
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
  Future<BaseResp<PinModel>> validatePin({
    String? pin,
    String? firebaseToken,
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.pinVerify,
      request: {
        'pin': pin,
        'firebase_token': firebaseToken,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, PinModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> forgotPin(
    String? accessToken,
    String? refreshToken,
    String? newPin,
    String? confirmPin,
  ) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.forgotPin,
      request: {
        'new_pin': newPin,
        'confirm_pin': confirmPin,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  // @override
  // Future<BaseResp> sendOtpForgotPin(SendOtpReq request) async {
  //   final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
  //         apiPath: ApiPath.otpSendForgot,
  //         request: request.toJson(),
  //       );
  //   switch (result.statusCode) {
  //     case 200:
  //       return BaseResp.fromJson(result.data, null);
  //     default:
  //       return handleErrors(result);
  //   }
  // }

  // @override
  // Future<BaseResp<VerifyOtpForgotModel>> verifyOtpForgotPin(
  //   VerifyOtpReq request,
  // ) async {
  //   final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
  //         apiPath: ApiPath.otpVerifyForgot,
  //         request: request.toJson(),
  //       );
  //   switch (result.statusCode) {
  //     case 200:
  //       return BaseResp.fromJson(result.data, VerifyOtpForgotModel.fromJson);
  //     default:
  //       return handleErrors(result);
  //   }
  // }
}
