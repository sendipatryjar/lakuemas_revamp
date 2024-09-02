import '../../features/gold_details/data/data_sources/gold_details_remote_data_source.dart';
import '../../features/gold_details/data/data_sources/interfaces/i_gold_details_remote_data_source.dart';
import '../../features/gold_details/data/repositories/gold_details_repository.dart';
import '../../features/gold_details/domain/respositories/i_gold_details_repository.dart';
import '../../features/gold_details/domain/usecases/get_gold_details_balance_uc.dart';
import '../../features/gold_details/domain/usecases/get_gold_income_uc.dart';
import '../../features/gold_details/presentation/blocs/gold_details_balances/gold_details_balances_bloc.dart';
import '../../features/gold_details/presentation/blocs/gold_income/gold_income_bloc.dart';
import '../../features/gold_details/presentation/cubits/gold_details_tab/gold_details_tab_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IGoldDetailsRemoteDataSource>(
      () => GoldDetailsRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<IGoldDetailsRepository>(() => GoldDetailsRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetGoldDetailsBalanceUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetGoldIncomeUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => GoldDetailsBalancesBloc(
        getGoldDetailsBalanceUc: sl(),
      ));
  sl.registerFactory(() => GoldIncomeBloc(
        getGoldIncomeUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => GoldDetailsTabCubit());
}
