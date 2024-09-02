import '../../features/notification/data/data_sources/interfaces/i_notification_remote_data_source.dart';
import '../../features/notification/data/data_sources/notification_remote_data_source.dart';
import '../../features/notification/data/repositories/notification_repository.dart';
import '../../features/notification/domain/repositories/i_notification_repository.dart';
import '../../features/notification/domain/usecases/get_notifications_uc.dart';
import '../../features/notification/domain/usecases/make_read_all_notif_uc.dart';
import '../../features/notification/domain/usecases/make_read_notif_uc.dart';
import '../../features/notification/presentation/blocs/notification_oth/notification_oth_bloc.dart';
import '../../features/notification/presentation/blocs/notification_read/notification_read_bloc.dart';
import '../../features/notification/presentation/cubits/notification/notification_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<INotificationRemoteDataSource>(
      () => NotificationRemoteDataSource(apiService: sl()));

  //! repositories
  sl.registerFactory<INotificationRepository>(() => NotificationRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetNotificationsUc(repository: sl()));
  sl.registerFactory(() => MakeReadNotifUc(repository: sl()));
  sl.registerFactory(() => MakeReadAllNotifUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => NotificationOthBloc(getNotificationsUc: sl()));
  sl.registerFactory(() => NotificationReadBloc(
        makeReadNotifUc: sl(),
        makeReadAllNotifUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => NotificationCubit());
}
