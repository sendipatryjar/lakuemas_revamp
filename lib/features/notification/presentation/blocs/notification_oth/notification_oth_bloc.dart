import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/models/data_with_meta.dart';
import '../../../domain/entities/notification_adjust_entity.dart';
import '../../../domain/usecases/get_notifications_uc.dart';

part 'notification_oth_event.dart';
part 'notification_oth_state.dart';

class NotificationOthBloc
    extends Bloc<NotificationOthEvent, NotificationOthState> {
  final GetNotificationsUc getNotificationsUc;

  NotificationOthBloc({required this.getNotificationsUc})
      : super(NotificationOthInitialState()) {
    on<NotificationOthGetEvent>((event, emit) async {
      emit(NotificationOthLoadingState());
      final result = await getNotificationsUc(
        page: event.page,
        isTransaction: false,
      );
      result.fold(
        (l) => emit(NotificationOthFailureState(l, l.code, l.messages)),
        (r) => emit(NotificationOthSuccessState(
          metaData: r.meta,
          notificationAdjust: r.data,
        )),
      );
    });
  }
}
