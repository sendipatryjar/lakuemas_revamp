import '../../features/kyc/data/data_sources/get_banks_remote_data_source.dart';
import '../../features/kyc/data/data_sources/interfaces/i_get_banks_remote_data_source.dart';
import '../../features/kyc/data/repositories/get_bank_repository.dart';
import '../../features/kyc/domain/repositories/i_get_banks_repository.dart';
import '../../features/kyc/domain/usecases/get_banks_uc.dart';
import '../../features/kyc/presentation/blocs/get_banks/get_banks_bloc.dart';
import '../../features/kyc/presentation/cubits/bank_account/bank_account_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IGetBanksRemoteDataSource>(
      () => GetBanksRemoteDataSource(apiService: sl()));

  //! repositories
  sl.registerFactory<IGetBanksRepository>(() => GetBanksRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetBanksUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => GetBanksBloc(getBanksUc: sl()));

  //! cubit
  sl.registerFactory(() => BankAccountCubit());
}
