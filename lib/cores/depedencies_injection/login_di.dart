import '../../features/login/data/data_sources/interfaces/i_login_remote_data_source.dart';
import '../../features/login/data/data_sources/login_remote_data_source.dart';
import '../../features/login/data/repositories/login_repository.dart';
import '../../features/login/domain/repositories/i_login_repository.dart';
import '../../features/login/domain/usecases/login_privy_uc.dart';
import '../../features/login/domain/usecases/login_uc.dart';
import '../../features/login/presentation/blocs/login/login_bloc.dart';
import '../../features/login/presentation/cubits/password_obsecure/password_obsecure_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ILoginRemoteDataSource>(
      () => LoginRemoteDataSource(apiService: sl()));

  //! repositories
  sl.registerFactory<ILoginRepository>(() =>
      LoginRepository(remoteDataSource: sl(), tokenLocalDataSource: sl()));

  //! usecases
  sl.registerFactory(() => LoginUc(repo: sl()));
  sl.registerFactory(() => LoginPrivyUc(repo: sl()));

  //! bloc
  sl.registerFactory(() => LoginBloc(loginUc: sl(), loginPrivyUc: sl()));

  //! cubit
  sl.registerFactory(() => PasswordObsecureCubit());
}
