import '../../../../../cores/models/base_resp.dart';
import '../../models/avatar_user_model.dart';

abstract class IAvatarRemoteDataSource {
  Future<BaseResp<AvatarUserModel>> createGuestAccount();
  Future<String?> guestAccountLinking({
    String? userId,
    String? partner,
  });
  Future<BaseResp> saveAvatar({
    String? accessToken,
    String? refreshToken,
    String? imageUrl,
  });
}
