import '../../features/physical_pull/data/data_sources/interfaces/i_physical_pull_remote_data_source.dart';
import '../../features/physical_pull/data/data_sources/physical_pull_remote_data_source.dart';
import '../../features/physical_pull/data/repositories/physical_pull_repository.dart';
import '../../features/physical_pull/domain/repositories/i_physical_pull_repository.dart';
import '../../features/physical_pull/domain/usecases/charge_uc.dart';
import '../../features/physical_pull/domain/usecases/get_list_gold_brand_uc.dart';
import '../../features/physical_pull/domain/usecases/get_store_uc.dart';
import '../../features/physical_pull/domain/usecases/physical_pull_checkout_uc.dart';
import '../../features/physical_pull/domain/usecases/physical_pull_gold_balance_uc.dart';
import '../../features/physical_pull/presentation/blocs/charge/charge_bloc.dart';
import '../../features/physical_pull/presentation/blocs/list_gold_brand/list_gold_brand_bloc.dart';
import '../../features/physical_pull/presentation/blocs/physical_pull_checkout/physical_pull_checkout_bloc.dart';
import '../../features/physical_pull/presentation/blocs/physical_pull_gold_balance/physical_pull_gold_balance_bloc.dart';
import '../../features/physical_pull/presentation/blocs/stores/stores_bloc.dart';
import '../../features/physical_pull/presentation/cubits/physical_pull/physical_pull_cubit.dart';
import '../../features/physical_pull/presentation/cubits/physical_pull_counter/physical_pull_counter_cubit.dart';
import '../../features/physical_pull/presentation/cubits/physical_pull_withdrawal_method/physical_pull_withdrawal_method_cubit.dart';
import '../../features/physical_pull/presentation/cubits/send_to_my_address/send_to_my_address_cubit.dart';
import '../../features/physical_pull/presentation/cubits/take_shop_data/take_shop_data_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IPhysicalPullRemoteDataSource>(
      () => PhysicalPullRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<IPhysicalPullRepository>(() => PhysicalPullRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => PhysicalPullGoldBalanceUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetListGoldBrandUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetStoreUc(
        repository: sl(),
      ));
  sl.registerFactory(() => ChargeUc(
        repository: sl(),
      ));
  sl.registerFactory(() => PhysicalPullCheckoutUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => PhysicalPullGoldBalanceBloc(
        physicalPullGoldBalanceUc: sl(),
      ));
  sl.registerFactory(() => ListGoldBrandBloc(
        getListGoldBrandUc: sl(),
      ));
  sl.registerFactory(() => StoresBloc(
        getStoreUc: sl(),
      ));
  sl.registerFactory(() => ChargeBloc(
        chargeUc: sl(),
      ));
  sl.registerFactory(() => PhysicalPullCheckoutBloc(
        physicalPullCheckoutUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => PhysicalPullCubit());
  sl.registerFactory(() => PhysicalPullCounterCubit());
  sl.registerFactory(() => PhysicalPullWithdrawalMethodCubit());
  sl.registerFactory(() => SendToMyAddressCubit());
  sl.registerFactory(() => TakeShopDataCubit());
}
