import '../../models/kyc_data_model.dart';

abstract class IKycLocalDataSource {
  Future<KycDataModel?> getKycData();
}
