import '../../features/laku_trade/data/data_sources/interfaces/i_laku_trade_remote_data_source.dart';
import '../../features/laku_trade/data/data_sources/laku_trade_remote_data_source.dart';
import '../../features/laku_trade/data/repositories/laku_trade_repository.dart';
import '../../features/laku_trade/domain/repositories/i_laku_trade_repository.dart';
import '../../features/laku_trade/domain/usecases/get_qr_data_laku_trade_uc.dart';
import '../../features/laku_trade/domain/usecases/laku_trade_checkout_uc.dart';
import '../../features/laku_trade/presentation/blocs/laku_trade_checkout/laku_trade_checkout_bloc.dart';
import '../../features/laku_trade/presentation/blocs/laku_trade_qr/laku_trade_qr_bloc.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ILakuTradeRemoteDataSource>(
      () => LakuTradeRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<ILakuTradeRepository>(() => LakuTradeRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetQrDataLakuTradeUc(
        repository: sl(),
      ));
  sl.registerFactory(() => LakuTradeCheckoutUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => LakuTradeQrBloc(
        getQrDataLakuTradeUc: sl(),
      ));
  sl.registerFactory(() => LakuTradeCheckoutBloc(
        lakuTradeCheckoutUc: sl(),
      ));

  //! cubit
}
