import '../../features/avatar/data/data_sources/avatar_local_data_source.dart';
import '../../features/avatar/data/data_sources/avatar_remote_data_source.dart';
import '../../features/avatar/data/data_sources/interfaces/i_avatar_local_data_source.dart';
import '../../features/avatar/data/data_sources/interfaces/i_avatar_remote_data_source.dart';
import '../../features/avatar/data/repositories/avatar_repository.dart';
import '../../features/avatar/domain/repositories/i_avatar_repository.dart';
import '../../features/avatar/domain/usecases/create_guest_account_uc.dart';
import '../../features/avatar/domain/usecases/guest_account_linking_uc.dart';
import '../../features/avatar/domain/usecases/save_avatar_uc.dart';
import '../../features/avatar/presentation/blocs/avatar_guest_account/avatar_guest_account_bloc.dart';
import '../../features/avatar/presentation/blocs/avatar_guest_linking/avatar_guest_linking_bloc.dart';
import '../../features/avatar/presentation/blocs/save_avatar/save_avatar_bloc.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IAvatarRemoteDataSource>(
      () => AvatarRemoteDataSource(apiService: sl()));
  sl.registerFactory<IAvatarLocalDataSource>(
      () => AvatarLocalDataSource(secureStorageService: sl()));

  //! repositories
  sl.registerFactory<IAvatarRepository>(() => AvatarRepository(
        remoteDataSource: sl(),
        localDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => CreateGuestAccountUc(repository: sl()));
  sl.registerFactory(() => GuestAccountLinkingUc(repository: sl()));
  sl.registerFactory(() => SaveAvatarUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => AvatarGuestAccountBloc(createGuestAccountUc: sl()));
  sl.registerFactory(() => AvatarGuestLinkingBloc(guestAccountLinkingUc: sl()));
  sl.registerFactory(() => SaveAvatarBloc(saveAvatarUc: sl()));

  //! cubit
  // sl.registerFactory(() => AvatarHelperCubit());
}
