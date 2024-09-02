import '../../constants/secure_storage_key.dart';
import '../../utils/app_utils.dart';
import '../crashlytics_service.dart';
import '../secure_storage_service.dart';
import 'i_token_local_data_source.dart';

class TokenLocalDataSource implements ITokenLocalDataSource {
  final SecureStorageService secureStorageService;

  TokenLocalDataSource({required this.secureStorageService});

  @override
  Future<void> saveAccessToken(String accToken) async {
    try {
      await secureStorageService.writeSecureData(
        key: ssAccessToken,
        value: accToken,
      );
    } catch (e, s) {
      String fc = '$this - saveAccessToken';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final result = await secureStorageService.readSecureData(ssAccessToken);
      return result;
    } catch (e, s) {
      String fc = '$this - getAccessToken';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
      return null;
    }
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await secureStorageService.writeSecureData(
        key: ssRefreshToken,
        value: refreshToken,
      );
    } catch (e, s) {
      String fc = '$this - saveRefreshToken';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final result = await secureStorageService.readSecureData(ssRefreshToken);
      return result;
    } catch (e, s) {
      String fc = '$this - getAccessToken';
      CrashlyticService.sendErrorGeneral(
        exception: e,
        stackTrace: s,
      );
      appPrintError('$fc error: $e');
      return null;
    }
  }
}
