import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/transaction/data/models/checkout_model.dart';
import '../../../_core/transaction/data/models/price_model.dart';
import '../../../_core/user/data/models/balance_model.dart';
import 'interfaces/i_buy_gold_remote_data_source.dart';

class BuyGoldRemoteDataSource implements IBuyGoldRemoteDataSource {
  final ApiService apiService;

  BuyGoldRemoteDataSource({required this.apiService});

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

  @override
  Future<BaseResp<PriceModel>> getPrice({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlInternalProcessService())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.priceSetting,
      request: {'type': 'purchase'},
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, PriceModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<CheckoutModel>> checkout(
      {String? accessToken,
      String? refreshToken,
      double? amount,
      String? amountType}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.buyGold,
      request: {'ammount': amount, 'ammount_type': amountType},
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, CheckoutModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
