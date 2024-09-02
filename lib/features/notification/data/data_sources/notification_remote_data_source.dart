import '../../../../cores/models/base_resp.dart';
import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/services/api_service.dart';
import '../models/notification_adjust_model.dart';
import '../models/notification_model.dart';
import 'interfaces/i_notification_remote_data_source.dart';

class NotificationRemoteDataSource implements INotificationRemoteDataSource {
  final ApiService apiService;

  NotificationRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<NotificationAdjustModel>> getNotifications({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
    bool? isTransaction,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.notifications,
      request: {
        'limit': limit,
        'page': page,
        'sort_by': sortBy,
        'order_by': orderBy,
        'is_transaction': isTransaction,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, NotificationAdjustModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> makeReadNotif({
    String? accessToken,
    String? refreshToken,
    int? id,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .put(
          apiPath: '${ApiPath.notifications}/$id/read',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, NotificationModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp> makeReadAllNotif(
      {String? accessToken, String? refreshToken}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: '${ApiPath.notifications}/read-all',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, NotificationModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}
