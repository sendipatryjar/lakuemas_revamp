import '../../domain/entities/notification_adjust_entity.dart';
import 'notification_model.dart';

class NotificationAdjustModel extends NotificationAdjustEntity {
  const NotificationAdjustModel({
    final int? unreadNotifications,
    final List<NotificationModel>? notifications,
  }) : super(
          unreadNotifications: unreadNotifications,
          notifications: notifications,
        );

  static NotificationAdjustModel fromJson(Map<String, dynamic> json) {
    List<NotificationModel>? notificationModel;
    if (json['list'] != null) {
      notificationModel = <NotificationModel>[];
      json['list'].forEach((v) {
        notificationModel!.add(NotificationModel.fromJson(v));
      });
    }
    return NotificationAdjustModel(
      unreadNotifications: json['unread_notifications'],
      notifications: notificationModel,
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['unread_notifications'] = unreadNotifications;
  //   if (notifications != null) {
  //     data['customer_address'] =
  //         notifications!.map((v) => NotificationModel().toJson()).toList();
  //   }
  //   return data;
  // }
}
