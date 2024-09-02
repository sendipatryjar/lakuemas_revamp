import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../entities/notification_adjust_entity.dart';

abstract class INotificationRepository {
  Future<Either<AppFailure, DataWithMeta<NotificationAdjustEntity?>>>
      getNotifications({
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
    bool? isTransaction,
  });
  Future<Either<AppFailure, bool>> makeReadNotif(int? id);
  Future<Either<AppFailure, bool>> makeReadAllNotif();
}
