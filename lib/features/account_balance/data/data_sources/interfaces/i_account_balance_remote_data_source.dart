import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/transaction/data/models/price_model.dart';
import '../../models/account_balance_faq_model.dart';
import '../../models/bank_me_model.dart';
import '../../models/mutation_model.dart';
import '../../models/withdrawal_model.dart';

abstract class IAccountBalanceRemoteDataSource {
  Future<BaseListResp<MutationModel>> getMutations({
    String? accessToken,
    String? refreshToken,
    int? status,
    String? period,
    String? startDate,
    String? endDate,
  });
  Future<BaseListResp<AccountBalanceFaqModel>> getFaq({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<PriceModel>> getPrice({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<BankMeModel>> getBankMe({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<WithdrawalModel>> withdraw({
    String? accessToken,
    String? refreshToken,
    int? amount,
  });
}
