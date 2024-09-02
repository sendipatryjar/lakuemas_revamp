import '../../features/redeem/data/data_sources/interfaces/i_voucher_redeem_remote_data_source.dart';
import '../../features/redeem/data/data_sources/voucher_redeem_remote_data_source.dart';
import '../../features/redeem/data/repositories/voucher_redeem_repository.dart';
import '../../features/redeem/domain/repositories/i_voucher_redeem_repository.dart';
import '../../features/redeem/domain/usecases/voucher_redeem_check_uc.dart';
import '../../features/redeem/domain/usecases/voucher_redeem_uc.dart';
import '../../features/redeem/presentaion/blocs/redeem/redeem_bloc.dart';
import '../../features/redeem/presentaion/blocs/redeem_check/redeem_check_bloc.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IVoucherRedeemRemoteDataSource>(
      () => VoucherRedeemRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<IVoucherRedeemRepository>(() => VoucherRedeemRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => VoucherRedeemCheckUc(
        repository: sl(),
      ));
  sl.registerFactory(() => VoucherRedeemUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => RedeemCheckBloc(
        voucherRedeemCheckUc: sl(),
      ));
  sl.registerFactory(() => RedeemBloc(
        voucherRedeemUc: sl(),
      ));

  //! cubit
}
