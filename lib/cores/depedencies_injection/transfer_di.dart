import '../../features/transfer/data/data_sources/interfaces/i_transfer_local_data_source.dart';
import '../../features/transfer/data/data_sources/interfaces/i_transfer_remote_data_source.dart';
import '../../features/transfer/data/data_sources/transfer_local_data_source.dart';
import '../../features/transfer/data/data_sources/transfer_remote_data_source.dart';
import '../../features/transfer/data/repositories/transfer_repository.dart';
import '../../features/transfer/domain/repositories/i_transfer_repository.dart';
import '../../features/transfer/domain/usecases/get_user_favorites_uc.dart';
import '../../features/transfer/domain/usecases/transfer_charge_uc.dart';
import '../../features/transfer/domain/usecases/transfer_checkout_uc.dart';
import '../../features/transfer/presentation/blocs/transfer_charge/transfer_charge_bloc.dart';
import '../../features/transfer/presentation/blocs/transfer_checkout/transfer_checkout_bloc.dart';
import '../../features/transfer/presentation/cubits/transfer/transfer_cubit.dart';
import '../../features/transfer/presentation/cubits/transfer_validation/transfer_validation_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ITransferRemoteDataSource>(() => TransferRemoteDataSource(
        apiService: sl(),
      ));
  sl.registerFactory<ITransferLocalDataSource>(() => TransferLocalDataSource(
        secureStorageService: sl(),
      ));

  //! repositories
  sl.registerFactory<ITransferRepository>(() => TransferRepository(
        remoteDataSource: sl(),
        localDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => TransferChargeUc(repository: sl()));
  sl.registerFactory(() => TransferCheckoutUc(repository: sl()));
  sl.registerFactory(() => GetUserFavoritesUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => TransferChargeBloc(transferChargeUc: sl()));
  sl.registerFactory(() => TransferCheckoutBloc(transferCheckoutUc: sl()));

  //! cubit
  sl.registerFactory(() => TransferCubit(getUserFavoritesUc: sl()));
  sl.registerFactory(() => TransferValidationCubit());
}
