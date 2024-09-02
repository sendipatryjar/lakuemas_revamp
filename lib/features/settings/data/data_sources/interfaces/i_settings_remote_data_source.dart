import '../../../../../cores/models/base_resp.dart';
import '../../models/update_settings_req.dart';

abstract class ISettingsRemoteDataSource {
  Future<BaseResp> updateSettings({
    String? accessToken,
    String? refreshToken,
    UpdateSettingsReq? request,
  });
}
