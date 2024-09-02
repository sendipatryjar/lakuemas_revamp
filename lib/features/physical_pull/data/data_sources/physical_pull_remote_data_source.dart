import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/transaction/data/models/checkout_model.dart';
import '../../../_core/user/data/models/balance_model.dart';
import '../models/list_gold_brand_model.dart';
import '../models/physical_pull_checkout_model.dart';
import '../models/physical_pull_checkout_req.dart';
import '../models/store_model.dart';
import 'interfaces/i_physical_pull_remote_data_source.dart';

class PhysicalPullRemoteDataSource implements IPhysicalPullRemoteDataSource {
  final ApiService apiService;

  PhysicalPullRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<BalanceModel>> getBalances(
      {String? accessToken, String? refreshToken}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.customerBalance,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, BalanceModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<ListGoldBrandModel>> getListGoldBrand({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlInternalProcessService())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.listGoldBrand,
      request: {
        'sort_by': 'asc',
        'cashout_enabled': true,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, ListGoldBrandModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<StoreModel>> getStore({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    int? cityId,
    String? sortBy,
    String? orderBy,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.stores,
      request: {
        'sort_by': 'asc',
        'city_id': cityId,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, StoreModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<CheckoutModel>> charge({
    String? accessToken,
    String? refreshToken,
    List<Map<String, dynamic>>? listPhysicalPullReq,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .postList(
          apiPath: ApiPath.charge,
          request: listPhysicalPullReq,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, CheckoutModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<PhysicalPullCheckoutModel>> physicalPullCheckout({
    String? accessToken,
    String? refreshToken,
    PhysicalPullCheckoutReq? physicalPullCheckoutReq,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: ApiPath.physicalPullCheckout,
          request: physicalPullCheckoutReq?.toJson(),
          // {
          //   "payment_method_id": physicalPullCheckoutReq?.paymentMethodId,
          //   "store_id": physicalPullCheckoutReq?.storeId,
          //   "courier_price_id": physicalPullCheckoutReq?.courierPriceId,
          //   "delivery_method": physicalPullCheckoutReq?.deliveryMethod,
          //   "destination_address": physicalPullCheckoutReq?.destinationAddress,
          //   "transaction_key": physicalPullCheckoutReq?.transactionKey,
          //   "jenius_cashtag": "",
          //   "ovo_phone_number": physicalPullCheckoutReq?.ovoPhoneNumber,
          // },
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(
            result.data, PhysicalPullCheckoutModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
