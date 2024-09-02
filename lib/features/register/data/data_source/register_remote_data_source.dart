import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/others/data/models/terms_and_conditions_model.dart';
import '../models/register_model.dart';
import '../models/register_req.dart';
import 'interfaces/i_register_remote_data_source.dart';

class RegisterRemoteDataSource implements IRegisterRemoteDataSource {
  final ApiService apiService;

  RegisterRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<RegisterModel>> register(RegisterReq registerReq) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.register,
          request: registerReq.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, RegisterModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<TermsAndConditionsModel>>
      getTermsAndConditionsRegister() async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).get(
          apiPath: ApiPath.termConditions,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, TermsAndConditionsModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<String?> getPrivacyPolicyRegister() async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).get(
          apiPath: ApiPath.privacyPolicy,
        );
    switch (result.statusCode) {
      case 200:
        return result.data;
      default:
        return handleErrors(result);
    }
  }
}
