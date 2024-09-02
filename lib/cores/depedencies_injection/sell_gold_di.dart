import '../../features/sell_gold/data/data_sources/interfaces/i_sell_gold_remote_data_source.dart';
import '../../features/sell_gold/data/data_sources/sell_gold_remote_data_source.dart';
import '../../features/sell_gold/data/repositories/sell_gold_repository.dart';
import '../../features/sell_gold/domain/repositories/i_sell_gold_repository.dart';
import '../../features/sell_gold/domain/usecases/get_balances_uc.dart';
import '../../features/sell_gold/domain/usecases/get_price_uc.dart';
import '../../features/sell_gold/domain/usecases/sell_gold_checkout_confirm_uc.dart';
import '../../features/sell_gold/domain/usecases/sell_gold_checkout_uc.dart';
import '../../features/sell_gold/presentation/blocs/balance/sgold_balance_bloc.dart';
import '../../features/sell_gold/presentation/blocs/pricing/sgold_pricing_bloc.dart';
import '../../features/sell_gold/presentation/blocs/sell_gold_checkout/sell_gold_checkout_bloc.dart';
import '../../features/sell_gold/presentation/blocs/sell_gold_checkout_confirm/sell_gold_checkout_confirm_bloc.dart';
import '../../features/sell_gold/presentation/cubits/buy_gold/sell_gold_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ISellGoldRemoteDataSource>(() => SellGoldRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<ISellGoldRepository>(() => SellGoldRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetBalancesUc(repository: sl()));
  sl.registerFactory(() => GetPriceUc(repository: sl()));
  sl.registerFactory(() => SellGoldCheckoutUc(repository: sl()));
  sl.registerFactory(() => SellGoldCheckoutConfirmUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => SgoldBalanceBloc(getBalancesUc: sl()));
  sl.registerFactory(() => SgoldPricingBloc(getPriceUc: sl()));
  sl.registerFactory(() => SellGoldCheckoutBloc(sellGoldCheckoutUc: sl()));
  sl.registerFactory(
      () => SellGoldCheckoutConfirmBloc(sellGoldCheckoutConfirmUc: sl()));

  //! cubit
  sl.registerFactory(() => SellGoldCubit());
}
