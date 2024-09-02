import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/user/data/models/balance_model.dart';
import 'interfaces/i_qr_transfer_remote_data_source.dart';

class QRTransferRemoteDataSource implements IQRTransferRemoteDataSource {
  final ApiService apiService;

  QRTransferRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<BalanceModel>> getBalances({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(apiPath: ApiPath.customerBalance);
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, BalanceModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
