import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../models/get_transactions_req.dart';
import '../../models/gold_deposit_model.dart';
import '../../models/lakusave_checkout_req.dart';
import '../../models/transaction_model.dart';

abstract class ILakusaveRemoteDataSource {
  Future<BaseResp<GoldDepositModel>> getMasterDataLakusave({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp> checkout({
    String? accessToken,
    String? refreshToken,
    required LakusaveCheckoutReq request,
  });
  Future<BaseResp> cancel({
    String? accessToken,
    String? refreshToken,
    String? transactionCode,
  });
  Future<BaseListResp<TransactionModel>> getTransactions({
    String? accessToken,
    String? refreshToken,
    required GetTransactionsReq request,
  });
  Future<BaseResp> updateExtend({
    String? accessToken,
    String? refreshToken,
    int? extendId,
    String? accountNumber,
  });
  Future<String?> getAbout({
    String? accessToken,
    String? refreshToken,
  });
}
