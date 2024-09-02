import '../../../../features/laku_trade/data/models/laku_trade_checkout_model.dart';
import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/laku_trade_qr_data_model.dart';
import 'interfaces/i_laku_trade_remote_data_source.dart';

class LakuTradeRemoteDataSource implements ILakuTradeRemoteDataSource {
  final ApiService apiService;

  LakuTradeRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<LakuTradeQrDataModel>> getQrData({
    String? accessToken,
    String? refreshToken,
    String? code,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(apiPath: '${ApiPath.lakuTradeQrCode}/$code');
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, LakuTradeQrDataModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<LakuTradeCheckoutModel>> checkout({
    String? accessToken,
    String? refreshToken,
    String? code,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(apiPath: '${ApiPath.lakuTradeQrCode}/$code');
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, LakuTradeCheckoutModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
