import '../../../../cores/models/base_resp.dart';

import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/services/api_service.dart';
import '../../../_core/others/data/models/terms_and_conditions_model.dart';
import '../../../_core/user/data/models/user_data_model.dart';
import '../models/change_password_req.dart';
import '../models/change_pin_req.dart';
import '../models/update_address_req.dart';
import '../models/update_user_data_req.dart';
import 'interfaces/i_profile_remote_data_source.dart';

class ProfileRemoteDataSource extends IProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<UserDataModel>> getUserData({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.customerMe,
      request: {'with_address': true},
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, UserDataModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> updateUserData(
      {String? accessToken,
      String? refreshToken,
      UpdateUserDataReq? request}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .put(
          apiPath: ApiPath.customer,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> updateAddress({
    String? accessToken,
    String? refreshToken,
    UpdateAddressReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .putList(
          apiPath: ApiPath.customerAddress,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> changePassword({
    String? accessToken,
    String? refreshToken,
    ChangePasswordReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: ApiPath.changePassword,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> changePin(
      {String? accessToken,
      String? refreshToken,
      ChangePinReq? request}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: ApiPath.changePin,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<TermsAndConditionsModel>> getTermsAndConditionsProfile({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).get(
          apiPath: ApiPath.termConditions,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, TermsAndConditionsModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
