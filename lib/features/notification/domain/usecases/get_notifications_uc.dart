import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../entities/notification_adjust_entity.dart';
import '../repositories/i_notification_repository.dart';

class GetNotificationsUc {
  final INotificationRepository repository;

  GetNotificationsUc({required this.repository});

  Future<Either<AppFailure, DataWithMeta<NotificationAdjustEntity?>>> call({
    int limit = 10,
    int page = 1,
    bool isTransaction = true,
  }) =>
      repository.getNotifications(
        limit: limit,
        page: page,
        orderBy: 'created_at',
        sortBy: 'desc',
        isTransaction: isTransaction,
      );
}
