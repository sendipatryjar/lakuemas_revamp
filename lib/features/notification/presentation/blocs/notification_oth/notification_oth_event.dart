part of 'notification_oth_bloc.dart';

abstract class NotificationOthEvent extends Equatable {
  final List data;
  const NotificationOthEvent(this.data);

  @override
  List<Object> get props => [data];
}

class NotificationOthGetEvent extends NotificationOthEvent {
  final int page;

  NotificationOthGetEvent({
    required this.page,
  }) : super([page]);
}
