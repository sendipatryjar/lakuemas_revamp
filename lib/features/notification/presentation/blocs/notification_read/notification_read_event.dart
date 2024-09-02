part of 'notification_read_bloc.dart';

sealed class NotificationReadEvent extends Equatable {
  const NotificationReadEvent();

  @override
  List<Object> get props => [];
}

class NotificationReadNowEvent extends NotificationReadEvent {
  final NotificationEntity notificationEntity;

  const NotificationReadNowEvent(this.notificationEntity);

  @override
  List<Object> get props => [
        [notificationEntity]
      ];
}

class NotificationReadAllNowEvent extends NotificationReadEvent {
  const NotificationReadAllNowEvent();

  @override
  List<Object> get props => [];
}
