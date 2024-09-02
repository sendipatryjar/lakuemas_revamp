import '../../features/coupon/data/data_sources/coupon_remote_data_source.dart';
import '../../features/coupon/data/data_sources/interfaces/i_coupon_remote_data_source.dart';
import '../../features/coupon/data/repositories/coupon_repository.dart';
import '../../features/coupon/domain/repositories/i_coupon_repository.dart';
import '../../features/coupon/domain/usecases/coupon_validation_uc.dart';
import '../../features/coupon/domain/usecases/get_coupon_detail_uc.dart';
import '../../features/coupon/domain/usecases/get_coupons_uc.dart';
import '../../features/coupon/presentation/blocs/coupon/coupon_bloc.dart';
import '../../features/coupon/presentation/blocs/coupon_detail/coupon_detail_bloc.dart';
import '../../features/coupon/presentation/blocs/coupon_validation/coupon_validation_bloc.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ICouponRemoteDataSource>(() => CouponRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<ICouponRepository>(() => CouponRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetCouponsUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetCouponDetailUc(
        repository: sl(),
      ));
  sl.registerFactory(() => CouponValidationUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => CouponBloc(getCouponsUc: sl()));
  sl.registerFactory(() => CouponDetailBloc(getCouponDetailUc: sl()));
  sl.registerFactory(() => CouponValidationBloc(couponValidationUc: sl()));

  //! cubit
}
