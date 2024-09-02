import '../../../../../cores/models/base_resp.dart';
import '../../models/notification_adjust_model.dart';

abstract class INotificationRemoteDataSource {
  Future<BaseResp<NotificationAdjustModel>> getNotifications({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
    bool? isTransaction,
  });

  Future<BaseResp> makeReadNotif({
    String? accessToken,
    String? refreshToken,
    int? id,
  });

  Future<BaseResp> makeReadAllNotif({
    String? accessToken,
    String? refreshToken,
  });
}
