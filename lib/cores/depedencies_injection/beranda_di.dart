import '../../features/beranda/data/data_sources/beranda_remote_data_source.dart';
import '../../features/beranda/data/data_sources/interfaces/i_beranda_remote_data_source.dart';
import '../../features/beranda/data/repositories/beranda_repository.dart';
import '../../features/beranda/domain/repositories/i_beranda_repository.dart';
import '../../features/beranda/domain/usecases/get_articles_uc.dart';
import '../../features/beranda/domain/usecases/get_gold_balance_uc.dart';
import '../../features/beranda/domain/usecases/get_menus_uc.dart';
import '../../features/beranda/domain/usecases/get_price_setting_uc.dart';
import '../../features/beranda/domain/usecases/get_promo_by_id_uc.dart';
import '../../features/beranda/domain/usecases/get_promos_uc.dart';
import '../../features/beranda/presentation/blocs/balance/balance_bloc.dart';
import '../../features/beranda/presentation/blocs/beranda_articles/beranda_articles_bloc.dart';
import '../../features/beranda/presentation/blocs/beranda_menus/beranda_menus_bloc.dart';
import '../../features/beranda/presentation/blocs/beranda_promo/beranda_promo_bloc.dart';
import '../../features/beranda/presentation/blocs/beranda_promo_detail/beranda_promo_detail_bloc.dart';
import '../../features/beranda/presentation/blocs/price_setting/price_setting_bloc.dart';
import '../../features/beranda/presentation/cubits/fab_cubit/fab_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IBerandaRemoteDataSource>(
      () => BerandaRemoteDataSource(apiService: sl()));

  //! repositories
  sl.registerFactory<IBerandaRepository>(() => BerandaRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => BerandaGetBalancesUc(repository: sl()));
  sl.registerFactory(() => GetMenusUc(repository: sl()));
  sl.registerFactory(() => BerandaGetArticlesUc(repository: sl()));
  sl.registerFactory(() => GetPriceSettingUc(repository: sl()));
  sl.registerFactory(() => GetPromosUc(repository: sl()));
  sl.registerFactory(() => GetPromoByIdUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => BerandaBalancesBloc(berandaGetBalancesUc: sl()));
  sl.registerFactory(() => BerandaMenusBloc(getMenusUc: sl()));
  sl.registerFactory(() => BerandaArticlesBloc(getArticlesUc: sl()));
  sl.registerFactory(() => PriceSettingBloc(getPriceSettingUc: sl()));
  sl.registerFactory(() => BerandaPromoBloc(getPromosUc: sl()));
  sl.registerFactory(() => BerandaPromoDetailBloc(getPromoByIdUc: sl()));

  //! cubit
  sl.registerFactory(() => FabCubit());
}
