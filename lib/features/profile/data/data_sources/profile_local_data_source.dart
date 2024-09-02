import 'dart:convert';

import '../../../../features/_core/user/data/models/user_data_model.dart';

import '../../../../cores/constants/secure_storage_key.dart';
import '../../../../cores/services/crashlytics_service.dart';
import '../../../../cores/services/secure_storage_service.dart';
import '../../../../cores/utils/app_utils.dart';
import 'interfaces/i_profile_local_data_source.dart';

class ProfileLocalDataSource implements IProfileLocalDataSource {
  final SecureStorageService secureStorageService;

  ProfileLocalDataSource({required this.secureStorageService});

  @override
  Future<void> saveUserData(UserDataModel userDataModel) async {
    try {
      final userDataJson = userDataModel.toJson();
      await secureStorageService.writeSecureData(
        key: ssUserData,
        value: jsonEncode(userDataJson),
      );
    } catch (e, s) {
      String fc = '$this - saveUserData';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
    }
  }

  @override
  Future<UserDataModel?> getUserData() async {
    try {
      final result = await secureStorageService.readSecureData(ssUserData);
      final result2 = jsonDecode(result ?? '');
      return UserDataModel.fromJson(result2);
    } catch (e, s) {
      String fc = '$this - getUserData';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
      return null;
    }
  }

  @override
  Future<void> saveIsElite(bool isElite) async {
    try {
      await secureStorageService.writeSecureData(
        key: ssIsElite,
        value: isElite.toString(),
      );
    } catch (e, s) {
      String fc = '$this - saveIsElite';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
    }
  }

  @override
  Future<bool> getIsElite() async {
    try {
      final result = await secureStorageService.readSecureData(ssIsElite);
      return result == 'true';
    } catch (e, s) {
      String fc = '$this - getIsElite';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
      return false;
    }
  }
}
