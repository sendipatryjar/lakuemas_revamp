part of 'notification_read_bloc.dart';

sealed class NotificationReadState extends Equatable {
  const NotificationReadState();

  @override
  List<Object> get props => [];
}

class NotificationReadInitialState extends NotificationReadState {}

class NotificationReadLoadingState extends NotificationReadState {}

class NotificationReadSuccessState extends NotificationReadState {
  final NotificationEntity? notificationEntity;

  const NotificationReadSuccessState(this.notificationEntity);

  @override
  List<Object> get props => [
        [notificationEntity]
      ];
}

class NotificationReadFailureState extends NotificationReadState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const NotificationReadFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
