import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/user/data/models/balance_model.dart';
import '../../models/detail_transaction_model.dart';
import '../../models/payment_method_model.dart';
import '../../models/payment_model.dart';
import '../../models/payment_req.dart';
import '../../models/update_status_model.dart';

abstract class IPaymentRemoteDataSource {
  Future<BaseListResp<PaymentMethodModel>> getPaymentMethods({
    String? accessToken,
    String? refreshToken,
    String? actionType,
  });
  Future<BaseListResp<BalanceModel>> getAccountBalance({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<PaymentModel>> payment({
    String? accessToken,
    String? refreshToken,
    PaymentReq? request,
  });
  Future<BaseResp<DetailTransactionModel>> getDetailTransaction({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  });
  Future<BaseResp<DetailTransactionModel>> getDetailTransactioWithdraw({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  });
  Future<BaseResp<DetailTransactionModel>> getDetailTransactionElite({
    String? accessToken,
    String? refreshToken,
    String? code,
  });
  Future<BaseResp<UpdateStatusModel>> updateStatus({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  });
  Future<BaseResp> cancelTransaction({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  });
}
