import '../../../../../cores/models/base_resp.dart';
import '../../../../_core/others/data/models/terms_and_conditions_model.dart';
import '../../../../_core/user/data/models/user_data_model.dart';
import '../../models/change_password_req.dart';
import '../../models/change_pin_req.dart';
import '../../models/update_address_req.dart';
import '../../models/update_user_data_req.dart';

abstract class IProfileRemoteDataSource {
  Future<BaseResp<UserDataModel>> getUserData({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp> updateUserData({
    String? accessToken,
    String? refreshToken,
    UpdateUserDataReq? request,
  });
  Future<BaseResp> updateAddress({
    String? accessToken,
    String? refreshToken,
    UpdateAddressReq? request,
  });
  Future<BaseResp> changePassword({
    String? accessToken,
    String? refreshToken,
    ChangePasswordReq? request,
  });
  Future<BaseResp> changePin({
    String? accessToken,
    String? refreshToken,
    ChangePinReq? request,
  });
  Future<BaseResp<TermsAndConditionsModel>> getTermsAndConditionsProfile({
    String? accessToken,
    String? refreshToken,
  });
}
