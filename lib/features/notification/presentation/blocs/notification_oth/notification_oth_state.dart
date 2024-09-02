part of 'notification_oth_bloc.dart';

abstract class NotificationOthState extends Equatable {
  const NotificationOthState();

  @override
  List<Object> get props => [];
}

class NotificationOthInitialState extends NotificationOthState {}

class NotificationOthLoadingState extends NotificationOthState {}

class NotificationOthSuccessState extends NotificationOthState {
  final MetaDataApi? metaData;
  final NotificationAdjustEntity? notificationAdjust;

  const NotificationOthSuccessState({this.metaData, this.notificationAdjust});

  @override
  List<Object> get props => [
        [metaData, notificationAdjust]
      ];
}

class NotificationOthFailureState extends NotificationOthState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const NotificationOthFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
