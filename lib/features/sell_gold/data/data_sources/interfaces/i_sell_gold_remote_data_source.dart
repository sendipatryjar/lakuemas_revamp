import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/transaction/data/models/checkout_model.dart';
import '../../../../_core/transaction/data/models/price_model.dart';
import '../../../../_core/user/data/models/balance_model.dart';
import '../../models/checkout_confirm_model.dart';

abstract class ISellGoldRemoteDataSource {
  Future<BaseListResp<BalanceModel>> getBalances({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<PriceModel>> getPrice({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<CheckoutModel>> checkout({
    String? accessToken,
    String? refreshToken,
    double? amount,
    String? amountType,
  });
  Future<BaseResp<CheckoutConfirmModel>> checkoutConfirm({
    String? accessToken,
    String? refreshToken,
    String? transactionKey,
  });
}
