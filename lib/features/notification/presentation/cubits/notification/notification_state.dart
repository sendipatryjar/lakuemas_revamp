part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final int unreadNotif;
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final bool isError;
  final MetaDataApi? meta;

  const NotificationState({
    this.unreadNotif = 0,
    this.notifications = const [],
    this.isLoading = false,
    this.isError = false,
    this.meta,
  });

  NotificationState copyWith({
    int? unreadNotif,
    List<NotificationEntity>? notifications,
    bool? isLoading,
    bool? isError,
    MetaDataApi? meta,
  }) =>
      NotificationState(
        unreadNotif: unreadNotif ?? this.unreadNotif,
        notifications: notifications ?? this.notifications,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        meta: meta ?? this.meta,
      );

  @override
  List<Object> get props => [
        unreadNotif,
        notifications,
        isLoading,
        isError,
        [meta],
      ];
}
