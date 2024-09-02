import '../../../../../cores/models/base_resp.dart';
import '../../models/chart_duration_model.dart';

abstract class IGoldPriceChartRemoteDataSource {
  Future<BaseResp<ChartDurationModel>> getChart({
    String? accessToken,
    String? refreshToken,
  });
}
