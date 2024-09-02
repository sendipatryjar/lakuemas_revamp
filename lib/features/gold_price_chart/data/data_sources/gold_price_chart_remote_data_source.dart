import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/chart_duration_model.dart';
import 'interfaces/i_gold_price_chart_remote_data_source.dart';

class GoldPriceChartRemoteDataSource
    implements IGoldPriceChartRemoteDataSource {
  final ApiService apiService;

  GoldPriceChartRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<ChartDurationModel>> getChart({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlInternalProcessService())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.goldPriceChart,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, ChartDurationModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
