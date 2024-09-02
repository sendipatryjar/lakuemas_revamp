import '../../../../../cores/models/base_resp.dart';

abstract class ICloseAccountRemoteDataSource {
  Future<BaseResp> submit({
    required String accessToken,
    required String refreshToken,
    required String reason,
  });
}
