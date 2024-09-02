import '../../../../_core/user/data/models/user_data_model.dart';

abstract class ITransferLocalDataSource {
  Future<UserDataModel?> getUserData();
}
