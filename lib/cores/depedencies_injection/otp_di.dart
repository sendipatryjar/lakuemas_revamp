import '../../features/otp/data/data_sources/interfaces/i_otp_remote_data_source.dart';
import '../../features/otp/data/data_sources/otp_remote_data_source.dart';
import '../../features/otp/data/repositories/otp_reposotry.dart';
import '../../features/otp/domain/repositories/i_otp_repository.dart';
import '../../features/otp/domain/usecases/send_otp_uc.dart';
import '../../features/otp/domain/usecases/verify_otp_uc.dart';
import '../../features/otp/presentation/blocks/otp/otp_bloc.dart';
import '../services/cubits/countdown/countdown_cubit.dart';
import '../../features/otp/presentation/cubits/otp_validation/otp_validation_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IOtpRemoteDataSource>(
      () => OtpRemoteDataSource(apiService: sl()));

  //! repositories
  sl.registerFactory<IOtpRepository>(() => OtpRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => SendOtpUc(repo: sl()));
  sl.registerFactory(() => VerifyOtpUc(repo: sl()));

  //! bloc
  sl.registerFactory(() => OtpBloc(sendOtpUc: sl(), verifyOtpUc: sl()));

  //! cubit
  sl.registerFactory(() => CountdownCubit());
  sl.registerFactory(() => OtpValidationCubit());
}
