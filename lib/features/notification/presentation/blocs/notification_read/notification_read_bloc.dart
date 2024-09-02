import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/make_read_all_notif_uc.dart';
import '../../../domain/usecases/make_read_notif_uc.dart';

part 'notification_read_event.dart';
part 'notification_read_state.dart';

class NotificationReadBloc
    extends Bloc<NotificationReadEvent, NotificationReadState> {
  final MakeReadNotifUc makeReadNotifUc;
  final MakeReadAllNotifUc makeReadAllNotifUc;

  NotificationReadBloc({
    required this.makeReadNotifUc,
    required this.makeReadAllNotifUc,
  }) : super(NotificationReadInitialState()) {
    on<NotificationReadNowEvent>((event, emit) async {
      emit(NotificationReadLoadingState());
      final result = await makeReadNotifUc(event.notificationEntity.id);
      result.fold(
        (l) => emit(NotificationReadFailureState(l, l.code, l.messages)),
        (r) => emit(NotificationReadSuccessState(event.notificationEntity)),
      );
    });

    on<NotificationReadAllNowEvent>((event, emit) async {
      emit(NotificationReadLoadingState());
      final result = await makeReadAllNotifUc();
      result.fold(
        (l) => emit(NotificationReadFailureState(l, l.code, l.messages)),
        (r) => emit(const NotificationReadSuccessState(null)),
      );
    });
  }
}
