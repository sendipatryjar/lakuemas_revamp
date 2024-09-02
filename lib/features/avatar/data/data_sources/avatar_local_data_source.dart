import 'dart:convert';

import '../../../../cores/constants/secure_storage_key.dart';
import '../../../../cores/services/crashlytics_service.dart';
import '../../../../cores/services/secure_storage_service.dart';
import '../../../../cores/utils/app_utils.dart';
import '../models/avatar_user_model.dart';
import 'interfaces/i_avatar_local_data_source.dart';

class AvatarLocalDataSource implements IAvatarLocalDataSource {
  final SecureStorageService secureStorageService;

  AvatarLocalDataSource({required this.secureStorageService});

  @override
  Future<void> saveAvatarGuestUser(AvatarUserModel? avatarUserModel) async {
    try {
      final userDataJson = avatarUserModel?.toJson();
      await secureStorageService.writeSecureData(
        key: ssAvatarUserGuest,
        value: jsonEncode(userDataJson),
      );
    } catch (e, s) {
      String fc = '$this - saveAvatarGuestUser';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
    }
  }

  @override
  Future<AvatarUserModel?> getAvatarGuestUser() async {
    try {
      final result =
          await secureStorageService.readSecureData(ssAvatarUserGuest);
      if (result != null) {
        final result2 = jsonDecode(result);
        final avatarUserGuest = AvatarUserModel.fromJson(result2);
        return avatarUserGuest;
      }
      return null;
    } catch (e, s) {
      String fc = '$this - getAvatarGuestUser';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
      return null;
    }
  }

  @override
  Future<void> saveAvatarTokenIframe(String? token) async {
    try {
      await secureStorageService.writeSecureData(
        key: ssAvatarTokenIframe,
        value: token,
      );
    } catch (e, s) {
      String fc = '$this - saveAvatarTokenIframe';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
    }
  }

  @override
  Future<String?> getAvatarTokenIframe() async {
    try {
      final result =
          await secureStorageService.readSecureData(ssAvatarTokenIframe);
      return result;
    } catch (e, s) {
      String fc = '$this - getAvatarTokenIframe';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
      return null;
    }
  }
}
