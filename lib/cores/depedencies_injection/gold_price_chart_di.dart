import '../../features/gold_price_chart/data/data_sources/gold_price_chart_remote_data_source.dart';
import '../../features/gold_price_chart/data/data_sources/interfaces/i_gold_price_chart_remote_data_source.dart';
import '../../features/gold_price_chart/data/repositories/gold_price_chart_repository.dart';
import '../../features/gold_price_chart/domain/repositories/i_gold_price_chart_repository.dart';
import '../../features/gold_price_chart/domain/usecases/get_chart_uc.dart';
import '../../features/gold_price_chart/presentation/blocs/bloc/get_chart_bloc.dart';
import '../../features/gold_price_chart/presentation/cubits/filter_tab/filter_tab_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IGoldPriceChartRemoteDataSource>(
      () => GoldPriceChartRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<IGoldPriceChartRepository>(() => GoldPriceChartRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetChartUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => GetChartBloc(getChartUc: sl()));

  //! cubit
  sl.registerFactory(() => FilterTabCubit());
}
