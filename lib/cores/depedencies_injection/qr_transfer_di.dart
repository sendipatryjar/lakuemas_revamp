import '../../features/qr_transfer/data/data_sources/interfaces/i_qr_transfer_remote_data_source.dart';
import '../../features/qr_transfer/data/data_sources/qr_transfer_remote_data_source.dart';
import '../../features/qr_transfer/data/repositories/qr_transfer_repository.dart';
import '../../features/qr_transfer/domain/repositories/i_qr_transfer_repository.dart';
import '../../features/qr_transfer/domain/usecases/get_balances_uc.dart';
import '../../features/qr_transfer/presentation/blocs/balance/balance_bloc.dart';
import '../../features/qr_transfer/presentation/cubits/qr_transfer/qr_transfer_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IQRTransferRemoteDataSource>(
      () => QRTransferRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<IQRTransferRepository>(() => QRTransferRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => QRTransferGetBalanceUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => QRTransferBalanceBloc(
        qrTransferGetBalanceUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => QrTransferCubit());
}
