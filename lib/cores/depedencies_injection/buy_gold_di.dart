import '../../features/buy_gold/data/data_sources/buy_gold_remote_data_source.dart';
import '../../features/buy_gold/data/data_sources/interfaces/i_buy_gold_remote_data_source.dart';
import '../../features/buy_gold/data/repositories/buy_gold_repository.dart';
import '../../features/buy_gold/domain/repositories/i_buy_gold_repository.dart';
import '../../features/buy_gold/domain/usecases/checkout_uc.dart';
import '../../features/buy_gold/domain/usecases/get_balances_uc.dart';
import '../../features/buy_gold/domain/usecases/get_price_uc.dart';
import '../../features/buy_gold/presentation/blocs/balance/bgold_balance_bloc.dart';
import '../../features/buy_gold/presentation/blocs/checkout/checkout_bloc.dart';
import '../../features/buy_gold/presentation/blocs/pricing/pricing_bloc.dart';
import '../../features/buy_gold/presentation/cubits/buy_gold/buy_gold_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IBuyGoldRemoteDataSource>(() => BuyGoldRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<IBuyGoldRepository>(() => BuyGoldRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetBalancesUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetPriceUc(
        repository: sl(),
      ));
  sl.registerFactory(() => CheckoutUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => BgoldBalanceBloc(
        getBalancesUc: sl(),
      ));
  sl.registerFactory(() => PricingBloc(
        getPriceUc: sl(),
      ));
  sl.registerFactory(() => CheckoutBloc(
        checkoutUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => BuyGoldCubit());
}
