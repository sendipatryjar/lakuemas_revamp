import '../../../../../cores/models/base_resp.dart';
import '../../models/pin_model.dart';

abstract class IPinRemoteDataSource {
  Future<BaseResp> createPin({
    String? pin,
    String? pinConfirmation,
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<PinModel>> validatePin({
    String? pin,
    String? firebaseToken,
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp> forgotPin(
    String? accessToken,
    String? refreshToken,
    String? newPin,
    String? confirmPin,
  );
  // Future<BaseResp> sendOtpForgotPin(SendOtpReq request);
  // Future<BaseResp<VerifyOtpForgotModel>> verifyOtpForgotPin(
  //     VerifyOtpReq request);
}
