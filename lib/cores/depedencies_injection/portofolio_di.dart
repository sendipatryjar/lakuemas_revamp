import '../../features/portofolio/data/data_source/interfaces/i_portofolio_remote_data_source.dart';
import '../../features/portofolio/data/data_source/portofolio_remote_data_source.dart';
import '../../features/portofolio/data/repositories/portofolio_repository.dart';
import '../../features/portofolio/domain/repositories/i_portofolio_repository.dart';
import '../../features/portofolio/domain/usecases/get_portofolio_uc.dart';
import '../../features/portofolio/domain/usecases/trx_history_uc.dart';
import '../../features/portofolio/presentation/blocs/get_portofolio/get_portofolio_bloc.dart';
import '../../features/portofolio/presentation/blocs/trx_history/trx_history_bloc.dart';
import '../../features/portofolio/presentation/cubits/trx_history/trx_history_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IPortofolioRemoteDataSource>(
      () => PortofolioRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<IPortofolioRepository>(() => PortofolioRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => TrxHistoryUc(repository: sl()));
  sl.registerFactory(() => GetPortofolioUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => TrxHistoryBloc(trxHistoryUc: sl()));
  sl.registerFactory(() => GetPortofolioBloc(getPortofolioUc: sl()));

  //! cubit
  sl.registerFactory(() => TrxHistoryCubit());
}
