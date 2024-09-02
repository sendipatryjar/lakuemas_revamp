import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/models/data_with_meta.dart';
import '../../../domain/entities/notification_entity.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState());

  void updateLoadingTrue() => emit(state.copyWith(isLoading: true));
  void updateErrorTrue() => emit(state.copyWith(isError: true));

  void resetNotification() => emit(const NotificationState());

  void updateNotification({
    required int page,
    required List<NotificationEntity> notifs,
    required int unreadNotif,
    required MetaDataApi? metaData,
  }) {
    List<NotificationEntity> data = [];
    data.addAll(state.notifications);
    data.addAll(notifs);
    emit(const NotificationState());
    emit(state.copyWith(
      unreadNotif: unreadNotif,
      notifications: data,
      isLoading: false,
      isError: false,
      meta: metaData,
    ));
  }

  void makeRead(NotificationEntity? value, [int? unreadNotif]) {
    List<NotificationEntity> data = [];
    data.addAll(state.notifications);
    var selectedList = data.where((element) => element.id == value?.id);
    NotificationEntity? selected =
        selectedList.isNotEmpty ? selectedList.first.copyWith(isRead: 1) : null;
    if (selected != null) {
      final index = data.indexWhere((value) => value.id == selected.id);
      data[index] = selected;
      emit(state.copyWith(
        notifications: data,
        unreadNotif: unreadNotif ?? (state.unreadNotif - 1),
      ));
    }
  }

  void makeReadAll() {
    List<NotificationEntity> data = [];
    data.addAll(state.notifications);
    for (var element in data) {
      makeRead(element, 0);
    }
  }
}
