import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/update_settings_req.dart';
import 'interfaces/i_settings_remote_data_source.dart';

class SettingsRemoteDataSource implements ISettingsRemoteDataSource {
  final ApiService apiService;

  SettingsRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp> updateSettings({
    String? accessToken,
    String? refreshToken,
    UpdateSettingsReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .put(
          apiPath: ApiPath.customerSetting,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }
}
