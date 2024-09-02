import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/user/data/models/balance_model.dart';
import '../models/detail_transaction_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/payment_req.dart';
import '../models/update_status_model.dart';
import 'interfaces/i_payment_remote_data_source.dart';

class PaymentRemoteDataSource implements IPaymentRemoteDataSource {
  final ApiService apiService;

  PaymentRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<PaymentMethodModel>> getPaymentMethods(
      {String? accessToken, String? refreshToken, String? actionType}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.paymentMethods,
      request: {'action_type': actionType},
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, PaymentMethodModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<BalanceModel>> getAccountBalance(
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
  Future<BaseResp<PaymentModel>> payment(
      {String? accessToken, String? refreshToken, PaymentReq? request}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: ApiPath.payment,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, PaymentModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<DetailTransactionModel>> getDetailTransaction({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: '${ApiPath.detailTransaction}/$transactionCode',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, DetailTransactionModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<DetailTransactionModel>> getDetailTransactioWithdraw({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath:
              '${ApiPath.accountBalanceTransaction}/$transactionCode/withdrawal',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, DetailTransactionModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<UpdateStatusModel>> updateStatus(
      {String? accessToken,
      String? refreshToken,
      String? transactionCode}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: '${ApiPath.detailTransaction}/$transactionCode/status',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, UpdateStatusModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<DetailTransactionModel>> getDetailTransactionElite({
    String? accessToken,
    String? refreshToken,
    String? code,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: '${ApiPath.eliteHistory}/$code',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, DetailTransactionModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> cancelTransaction({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: '${ApiPath.transactions}/$transactionCode/cancel',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }
}
