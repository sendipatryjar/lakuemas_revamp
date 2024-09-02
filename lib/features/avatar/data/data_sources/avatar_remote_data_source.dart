import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/constants/avatar_const.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/avatar_user_model.dart';
import 'interfaces/i_avatar_remote_data_source.dart';

class AvatarRemoteDataSource implements IAvatarRemoteDataSource {
  final ApiService apiService;

  AvatarRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<AvatarUserModel>> createGuestAccount() async {
    final result = await apiService
        .baseUrl(Environment.readyPlayerMeBaseUrl(null))
        .addOtherHeader(
      headers: {
        'x-api-key': AvatarConst.apiKey,
      },
    ).post(
      apiPath: '/v1/users',
      request: {
        'data': {
          'applicationId': AvatarConst.applicationId,
        },
      },
    );
    switch (result.statusCode) {
      case 200:
      case 201:
        return BaseResp.fromJson(result.data, AvatarUserModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<String?> guestAccountLinking({
    String? userId,
    String? partner,
  }) async {
    final result = await apiService
        .baseUrl(Environment.readyPlayerMeBaseUrl(null))
        .addOtherHeader(
      headers: {
        'x-api-key': AvatarConst.apiKey,
      },
    ).get(
      apiPath: '/v1/auth/token',
      request: {
        'userId': userId,
        'partner': partner,
      },
    );
    switch (result.statusCode) {
      case 200:
        return result.data?['data']['token'];
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> saveAvatar({
    String? accessToken,
    String? refreshToken,
    String? imageUrl,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.customerAvatar,
      request: {
        'image_url': imageUrl,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, null);
      default:
        return handleErrors(result);
    }
  }
}
