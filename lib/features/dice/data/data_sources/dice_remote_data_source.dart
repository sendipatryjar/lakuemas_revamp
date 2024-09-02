import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import 'interfaces/i_dice_remote_data_source.dart';

class DiceRemoteDataSource implements IDiceRemoteDataSource {
  final ApiService apiService;

  DiceRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp> gatcha({
    String? accessToken,
    String? refreshToken,
    int? qty,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.diceGatcha,
      request: {
        "qty": qty,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }
}
