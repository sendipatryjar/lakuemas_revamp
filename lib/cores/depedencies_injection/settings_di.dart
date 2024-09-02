import '../../features/settings/data/data_sources/interfaces/i_settings_remote_data_source.dart';
import '../../features/settings/data/data_sources/settings_remote_data_source.dart';
import '../../features/settings/data/repositories/settings_repository.dart';
import '../../features/settings/domain/repositories/i_settings_repository.dart';
import '../../features/settings/domain/usecases/update_settings_uc.dart';
import '../../features/settings/presentation/blocs/update_settings/update_settings_bloc.dart';
import '../../features/settings/presentation/cubits/setting_data/setting_data_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ISettingsRemoteDataSource>(() => SettingsRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<ISettingsRepository>(() => SettingsRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => UpdateSettingsUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => UpdateSettingsBloc(
        updateSettingsUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => SettingDataCubit(
        getUserDataUc: sl(),
      ));
}
