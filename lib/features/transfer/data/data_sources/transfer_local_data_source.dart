import 'dart:convert';

import '../../../../cores/constants/secure_storage_key.dart';
import '../../../../cores/services/crashlytics_service.dart';
import '../../../../cores/services/secure_storage_service.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../_core/user/data/models/user_data_model.dart';
import 'interfaces/i_transfer_local_data_source.dart';

class TransferLocalDataSource implements ITransferLocalDataSource {
  final SecureStorageService secureStorageService;

  TransferLocalDataSource({required this.secureStorageService});

  @override
  Future<UserDataModel?> getUserData() async {
    try {
      final result = await secureStorageService.readSecureData(ssUserData);
      final result2 = jsonDecode(result ?? '');
      final userData = UserDataModel.fromJson(result2);
      return userData;
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
}
