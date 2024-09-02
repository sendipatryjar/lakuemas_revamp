import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/support_contact_model.dart';
import '../models/support_faq_model.dart';
import 'interfaces/i_support_remote_data_source.dart';

class SupportRemoteDataSource implements ISupportRemoteDataSource {
  final ApiService apiService;

  SupportRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<SupportFaqModel>> getFaq({
    String? accessToken,
    String? refreshToken,
    String? keyword,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        // .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.supportFaq,
          request: keyword != null ? {'keyword': keyword} : null,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, SupportFaqModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<SupportContactModel>> getSupportContacts({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlInternalProcessService())
        .get(
          apiPath: ApiPath.supportContact,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, SupportContactModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
