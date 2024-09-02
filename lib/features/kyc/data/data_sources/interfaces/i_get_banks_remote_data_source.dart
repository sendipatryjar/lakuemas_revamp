import '../../../../../cores/models/base_list_resp.dart';
import '../../models/banks_model.dart';
import '../../models/get_banks_req.dart';

abstract class IGetBanksRemoteDataSource {
  Future<BaseListResp<BankAccountModel>> bankAccount({
    String? accessToken,
    String? refreshToken,
    GetBanksReq? request,
  });
}
