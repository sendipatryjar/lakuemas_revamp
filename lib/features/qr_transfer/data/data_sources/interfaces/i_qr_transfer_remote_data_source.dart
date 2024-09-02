import '../../../../../cores/models/base_list_resp.dart';
import '../../../../_core/user/data/models/balance_model.dart';

abstract class IQRTransferRemoteDataSource {
  Future<BaseListResp<BalanceModel>> getBalances({
    String? accessToken,
    String? refreshToken,
  });
}
