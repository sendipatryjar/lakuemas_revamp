import '../../features/forgot/data/data_sources/forgot_password_remote_data_source.dart';
import '../../features/forgot/data/data_sources/interfaces/i_forgot_password_remote_data_source.dart';
import '../../features/forgot/data/repositories/forgot_password_repository.dart';
import '../../features/forgot/domain/repositories/i_forgot_password_repository.dart';
import '../../features/forgot/domain/usecases/forgot_password_uc.dart';
import '../../features/forgot/domain/usecases/send_otp_forgot_uc.dart';
import '../../features/forgot/domain/usecases/verify_otp_forgot_uc.dart';
import '../../features/forgot/presentation/blocs/forgot_password/forgot_password_bloc.dart';
import '../../features/forgot/presentation/blocs/otp_forgot/otp_forgot_bloc.dart';
import '../../features/forgot/presentation/cubits/change_obsecure/change_obsecure_cubit.dart';
import '../../features/forgot/presentation/cubits/forgot_password/forgot_password_validation_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IForgotPasswordRemoteDataSource>(
      () => ForgotPasswordRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<IForgotPasswordRepository>(() => ForgotPasswordRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => ForgotPasswordUc(
        repository: sl(),
      ));
  sl.registerFactory(() => SendOtpForgotUc(
        repository: sl(),
      ));
  sl.registerFactory(() => VerifyOtpForgotUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => ForgotPasswordBloc(
        forgotPasswordUc: sl(),
      ));
  sl.registerFactory(() => OtpForgotBloc(
        sendOtpForgotUc: sl(),
        verifyOtpForgotUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => ForgotPasswordValidationCubit());
  sl.registerFactory(() => ChangeObsecureCubit());
}
