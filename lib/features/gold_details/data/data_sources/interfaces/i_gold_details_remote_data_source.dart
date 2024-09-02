import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/user/data/models/balance_model.dart';
import '../../models/gold_income_model.dart';

abstract class IGoldDetailsRemoteDataSource {
  Future<BaseListResp<BalanceModel>> getBalances({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<GoldIncomeModel>> getGoldIncome({
    String? accessToken,
    String? refreshToken,
  });
}
