import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/others/data/models/terms_and_conditions_model.dart';
import '../../models/register_model.dart';
import '../../models/register_req.dart';

abstract class IRegisterRemoteDataSource {
  Future<BaseResp<RegisterModel>> register(RegisterReq registerReq);
  Future<BaseResp<TermsAndConditionsModel>> getTermsAndConditionsRegister();
  Future<String?> getPrivacyPolicyRegister();
}
