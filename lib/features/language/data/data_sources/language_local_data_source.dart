import 'dart:convert';

import '../../../../cores/constants/secure_storage_key.dart';
import '../../../../cores/services/secure_storage_service.dart';
import '../../../../cores/utils/app_utils.dart';
import '../models/language_model.dart';
import 'intefaces/i_language_local_data_source.dart';

class LanguageLocalDataSource implements ILanguageLocalDataSource {
  final SecureStorageService secureStorageService;

  LanguageLocalDataSource({required this.secureStorageService});

  @override
  Future<bool> insLang(LanguageModel? value) async {
    try {
      await secureStorageService.writeSecureData(
        key: ssLanguage,
        value: jsonEncode(value?.toJson()),
      );
      return true;
    } catch (e, _) {
      String fc = 'LanguageLocalDataSource - insLang';
      // CrashlyticService.sendErrorGeneral(
      //   exception: e,
      //   stackTrace: s,
      // );
      appPrintError('$fc error: $e');
      return false;
    }
  }

  @override
  Future<LanguageModel?> getLang() async {
    try {
      final result = await secureStorageService.readSecureData(ssLanguage);
      if (result != null && result.isNotEmpty) {
        final user = LanguageModel.fromJson(jsonDecode(result));
        return user;
      }
      return null;
    } catch (e, _) {
      String fc = 'LoginLocalDataSource - getLang';
      // CrashlyticService.sendErrorGeneral(
      //   exception: e,
      //   stackTrace: s,
      // );
      appPrintError('$fc error: $e');
      return null;
    }
  }
}
