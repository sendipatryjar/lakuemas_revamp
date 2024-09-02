import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import 'interfaces/i_close_account_remote_data_source.dart';

class CloseAccountRemoteDataSource implements ICloseAccountRemoteDataSource {
  final ApiService apiService;

  CloseAccountRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp> submit({
    required String accessToken,
    required String refreshToken,
    required String reason,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.closeAccountRequest,
      request: {'reason': reason},
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }
}
