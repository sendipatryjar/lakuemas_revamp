import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/transaction/data/models/price_model.dart';
import '../models/account_balance_faq_model.dart';
import '../models/bank_me_model.dart';
import '../models/mutation_model.dart';
import '../models/withdrawal_model.dart';
import 'interfaces/i_account_balance_remote_data_source.dart';

class AccountBalanceRemoteDataSource
    implements IAccountBalanceRemoteDataSource {
  final ApiService apiService;

  AccountBalanceRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<MutationModel>> getMutations({
    String? accessToken,
    String? refreshToken,
    int? status,
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.accountBalanceMutations,
      request: {
        ...status != null ? {'status': status} : {},
        ...period != null ? {'period': period} : {},
        ...startDate != null ? {'start_date': startDate} : {},
        ...endDate != null ? {'end_date': endDate} : {},
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, MutationModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<AccountBalanceFaqModel>> getFaq({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.accountBalanceFaq,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(
            result.data, AccountBalanceFaqModel.fromJson);
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
      request: {'type': 'withdrawal'},
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, PriceModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<BankMeModel>> getBankMe({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.banksMe,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, BankMeModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<WithdrawalModel>> withdraw({
    String? accessToken,
    String? refreshToken,
    int? amount,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
            apiPath: ApiPath.accountBalanceWithdraw,
            request: {'amount': amount});
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, WithdrawalModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
