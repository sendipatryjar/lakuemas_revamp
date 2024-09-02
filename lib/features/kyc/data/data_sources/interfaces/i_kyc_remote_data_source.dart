import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/user/data/models/user_data_model.dart';
import '../../models/liveness_url_model.dart';

abstract class IKycRemoteDataSource {
  Future<BaseResp<UserDataModel>> getUserData({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp> kycKtp({
    String? nik,
    String? name,
    String? pob,
    String? dob,
    List<int>? ktpPhotoBytes,
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp> kycSelfie({
    List<int>? selfiePhotoBytes,
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp> kycNpwp({
    String? accessToken,
    String? refreshToken,
    String? npwpNo,
    String? npwpPhotoBytes,
  });
  Future<BaseResp> kycSavings({
    String? accessToken,
    String? refreshToken,
    String? accountNumber,
    int? bankId,
  });
  Future<BaseResp<LivenessUrlModel>> genrateLivenessUrl({
    String? accessToken,
    String? refreshToken,
  });
}
