import '../../../../../cores/models/base_resp.dart';
import '../../models/login_model.dart';
import '../../models/login_req.dart';

abstract class ILoginRemoteDataSource {
  Future<BaseResp<LoginModel>> login(LoginReq request);
  Future<BaseResp<LoginModel>> loginPrivy({String? code});
}
