import '../../features/pin/data/data_sources/interfaces/i_pin_remote_data_source.dart';
import '../../features/pin/data/data_sources/pin_remote_data_source.dart';
import '../../features/pin/data/repositories/pin_repository.dart';
import '../../features/pin/domain/repositories/i_pin_repository.dart';
import '../../features/pin/domain/usecases/create_pin_uc.dart';
import '../../features/pin/domain/usecases/forgot_pin_uc.dart';
import '../../features/pin/domain/usecases/validate_pin_uc.dart';
import '../../features/pin/presentation/blocs/forgot_pin/forgot_pin_bloc.dart';
import '../../features/pin/presentation/blocs/pin/pin_bloc.dart';
import '../../features/pin/presentation/cubits/cubit/pin_create_helper_cubit.dart';
import '../../features/pin/presentation/cubits/forgot_pin_validation/forgot_pin_validation_cubit.dart';
import '../../features/pin/presentation/cubits/pin_typing/pin_typing_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IPinRemoteDataSource>(() => PinRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<IPinRepository>(() => PinRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => CreatePinUc(repository: sl()));
  sl.registerFactory(() => ValidatePinUc(repository: sl()));
  // sl.registerFactory(() => SendOtpForgotPinUc(repository: sl()));
  // sl.registerFactory(() => VerifyOtpForgotPinUc(repository: sl()));
  sl.registerFactory(() => ForgotPinUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => PinBloc(
        createPinUc: sl(),
        validatePinUc: sl(),
      ));
  // sl.registerFactory(() => OtpPinBloc(
  //       sendOtpForgotPinUc: sl(),
  //       verifyOtpForgotPinUc: sl(),
  //     ));
  sl.registerFactory(() => ForgotPinBloc(
        forgotPinUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => PinCreateHelperCubit());
  sl.registerFactory(() => PinTypingCubit());
  sl.registerFactory(() => ForgotPinValidationCubit());
}
