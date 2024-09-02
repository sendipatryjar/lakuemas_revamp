import '../../../../_core/user/data/models/user_data_model.dart';

abstract class IProfileLocalDataSource {
  Future<void> saveUserData(UserDataModel userDataModel);
  Future<UserDataModel?> getUserData();
  Future<void> saveIsElite(bool isElite);
  Future<bool> getIsElite();
}
