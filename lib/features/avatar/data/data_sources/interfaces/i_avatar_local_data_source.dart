import '../../models/avatar_user_model.dart';

abstract class IAvatarLocalDataSource {
  Future<void> saveAvatarGuestUser(AvatarUserModel? avatarUserModel);
  Future<AvatarUserModel?> getAvatarGuestUser();
  Future<void> saveAvatarTokenIframe(String? token);
  Future<String?> getAvatarTokenIframe();
}
