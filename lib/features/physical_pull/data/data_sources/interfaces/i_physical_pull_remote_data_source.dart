import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/transaction/data/models/checkout_model.dart';
import '../../../../_core/user/data/models/balance_model.dart';
import '../../models/list_gold_brand_model.dart';
import '../../models/physical_pull_checkout_model.dart';
import '../../models/physical_pull_checkout_req.dart';
import '../../models/store_model.dart';

abstract class IPhysicalPullRemoteDataSource {
  Future<BaseListResp<BalanceModel>> getBalances({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<ListGoldBrandModel>> getListGoldBrand({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<StoreModel>> getStore({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    int? cityId,
    String? sortBy,
  });
  Future<BaseResp<CheckoutModel>> charge({
    String? accessToken,
    String? refreshToken,
    List<Map<String, dynamic>>? listPhysicalPullReq,
  });
  Future<BaseResp<PhysicalPullCheckoutModel>> physicalPullCheckout({
    String? accessToken,
    String? refreshToken,
    PhysicalPullCheckoutReq? physicalPullCheckoutReq,
  });
}
