import 'package:equatable/equatable.dart';

import 'notification_entity.dart';

class NotificationAdjustEntity extends Equatable {
  final int? unreadNotifications;
  final List<NotificationEntity>? notifications;

  const NotificationAdjustEntity(
      {this.unreadNotifications, this.notifications});

  @override
  List<Object?> get props => [
        [unreadNotifications, notifications]
      ];
}
