import '../../../../features/kyc/data/models/banks_model.dart';
import '../../../../features/kyc/data/models/get_banks_req.dart';
import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/services/api_service.dart';
import 'interfaces/i_get_banks_remote_data_source.dart';

class GetBanksRemoteDataSource implements IGetBanksRemoteDataSource {
  final ApiService apiService;

  GetBanksRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<BankAccountModel>> bankAccount({
    String? accessToken,
    String? refreshToken,
    GetBanksReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.banks,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, BankAccountModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
