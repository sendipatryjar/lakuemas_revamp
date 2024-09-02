import '../../features/close_account/data/data_soures/close_account_remote_data_source.dart';
import '../../features/close_account/data/data_soures/interfaces/i_close_account_remote_data_source.dart';
import '../../features/close_account/data/repositories/close_account_repository.dart';
import '../../features/close_account/domain/repositories/i_close_account_repository.dart';
import '../../features/close_account/domain/usecases/close_account_submit_uc.dart';
import '../../features/close_account/presentation/blocs/close_account/close_account_bloc.dart';
import '../../features/close_account/presentation/cubits/cubit/close_account_validation_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ICloseAccountRemoteDataSource>(
      () => CloseAccountRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<ICloseAccountRepository>(() => CloseAccountRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => CloseAccountSubmitUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => CloseAccountBloc(
        closeAccountSubmitUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => CloseAccountValidationCubit());
}
