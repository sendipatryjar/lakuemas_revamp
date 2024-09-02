import '../../../../../cores/models/base_resp.dart';

abstract class IDiceRemoteDataSource {
  Future<BaseResp> gatcha({String? accessToken, String? refreshToken, int? qty});
}
