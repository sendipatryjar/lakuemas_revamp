import 'dart:convert';

import '../../../../cores/constants/secure_storage_key.dart';
import '../../../../cores/services/crashlytics_service.dart';
import '../../../../cores/services/secure_storage_service.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../_core/user/data/models/user_data_model.dart';
import '../models/kyc_data_model.dart';
import '../models/object_kyc_model.dart';
import 'interfaces/i_kyc_local_data_source.dart';

class KycLocalDataSource implements IKycLocalDataSource {
  final SecureStorageService secureStorageService;

  KycLocalDataSource({required this.secureStorageService});

  @override
  Future<KycDataModel?> getKycData() async {
    try {
      final result = await secureStorageService.readSecureData(ssUserData);
      final result2 = jsonDecode(result ?? '');
      final userData = UserDataModel.fromJson(result2);
      return KycDataModel(
        // id: userData.kycEntity?.id,
        // name: userData.kycEntity?.name,
        objectKyc: userData.kycEntity?.objectKyc?.map((key, value) => MapEntry(
            key,
            ObjectKycModel(
              bankId: value?.bankId,
              status: value?.status,
              number: value?.number,
              name: value?.name,
              pob: value?.pob,
              dob: value?.dob,
              imageUrl: value?.imageUrl,
              reason: value?.reason,
            ))),
      );
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
