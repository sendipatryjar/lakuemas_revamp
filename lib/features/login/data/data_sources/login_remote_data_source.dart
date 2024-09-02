import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/login_model.dart';
import '../models/login_req.dart';
import 'interfaces/i_login_remote_data_source.dart';

class LoginRemoteDataSource implements ILoginRemoteDataSource {
  final ApiService apiService;

  LoginRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<LoginModel>> login(LoginReq request) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
          apiPath: ApiPath.login,
          request: request.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, LoginModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<LoginModel>> loginPrivy({String? code}) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).post(
      apiPath: ApiPath.loginPrivy,
      request: {"code": code},
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, LoginModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
