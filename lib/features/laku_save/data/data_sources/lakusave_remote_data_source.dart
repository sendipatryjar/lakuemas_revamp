import '../../../../features/laku_save/data/models/get_transactions_req.dart';
import '../../../../features/laku_save/data/models/lakusave_checkout_req.dart';
import '../../../../features/laku_save/data/models/transaction_model.dart';
import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/gold_deposit_model.dart';
import 'interfaces/i_lakusave_remote_data_source.dart';

class LakusaveRemoteDataSource implements ILakusaveRemoteDataSource {
  final ApiService apiService;

  LakusaveRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<GoldDepositModel>> getMasterDataLakusave({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(apiPath: ApiPath.transactionsMaster, request: {
      'gold_deposit_enabled': true,
    });
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, GoldDepositModel.fromJson,
            result.data['data']['gold_deposit']);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> checkout(
      {String? accessToken,
      String? refreshToken,
      required LakusaveCheckoutReq request}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: ApiPath.goldDepositCheckout,
          request: request.toJson(),
          useFormData: false,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> cancel({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: '${ApiPath.goldDeposit}/$transactionCode/cancel',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<TransactionModel>> getTransactions({
    String? accessToken,
    String? refreshToken,
    required GetTransactionsReq request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.transactions,
          request: request.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, TransactionModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> updateExtend({
    String? accessToken,
    String? refreshToken,
    int? extendId,
    String? accountNumber,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .patch(
      apiPath: ApiPath.goldDepositExtend,
      request: {
        'extend_id': extendId,
        'account_number': accountNumber,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<String?> getAbout({String? accessToken, String? refreshToken}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.goldDepositAbout,
        );
    switch (result.statusCode) {
      case 200:
        return result.data;
      default:
        return handleErrors(result);
    }
  }
}
