import '../../features/kyc/data/data_sources/interfaces/i_kyc_local_data_source.dart';
import '../../features/kyc/data/data_sources/interfaces/i_kyc_remote_data_source.dart';
import '../../features/kyc/data/data_sources/kyc_local_data_source.dart';
import '../../features/kyc/data/data_sources/kyc_remote_data_souce.dart';
import '../../features/kyc/data/repositories/kyc_repository.dart';
import '../../features/kyc/domain/repositories/i_kyc_repository.dart';
import '../../features/kyc/domain/usecases/bank_account_uc.dart';
import '../../features/kyc/domain/usecases/generate_liveness_url_uc.dart';
import '../../features/kyc/domain/usecases/get_kyc_data_uc.dart';
import '../../features/kyc/domain/usecases/kyc_ktp_uc.dart';
import '../../features/kyc/domain/usecases/kyc_selfie_uc.dart';
import '../../features/kyc/domain/usecases/npwp_verification_uc.dart';
import '../../features/kyc/presentation/blocs/bank_account/bank_account_bloc.dart';
import '../../features/kyc/presentation/blocs/get_kyc_data/get_kyc_data_bloc.dart';
import '../../features/kyc/presentation/blocs/kyc_ktp/kyc_ktp_bloc.dart';
import '../../features/kyc/presentation/blocs/kyc_selfie/kyc_selfie_bloc.dart';
import '../../features/kyc/presentation/blocs/liveness/liveness_bloc.dart';
import '../../features/kyc/presentation/blocs/npwp/npwp_verification_bloc.dart';
import '../../features/kyc/presentation/cubits/bank_account_validation/bank_account_validation_cubit.dart';
import '../../features/kyc/presentation/cubits/camera/camera_cubit.dart';
import '../../features/kyc/presentation/cubits/ktp/ktp_validation_cubit.dart';
import '../../features/kyc/presentation/cubits/npwp/npwp_verification_validation_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IKycRemoteDataSource>(() => KycRemoteDataSource(
        apiService: sl(),
      ));
  sl.registerFactory<IKycLocalDataSource>(() => KycLocalDataSource(
        secureStorageService: sl(),
      ));

  //! repositories
  sl.registerFactory<IKycRepository>(() => KycRepository(
        remoteDataSource: sl(),
        localDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetKycDataUc(
        repository: sl(),
      ));
  sl.registerFactory(() => KycKtpUc(
        repository: sl(),
      ));
  sl.registerFactory(() => KycSelfieUc(
        repository: sl(),
      ));
  sl.registerFactory(() => NpwpVerificationUc(
        repository: sl(),
      ));
  sl.registerFactory(() => BankAccountUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GenerateLivenessUrlUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => GetKycDataBloc(
        getKycDataUc: sl(),
      ));
  sl.registerFactory(() => KycKtpBloc(
        kycKtpUc: sl(),
      ));
  sl.registerFactory(() => KycSelfieBloc(
        kycSelfieUc: sl(),
      ));
  sl.registerFactory(() => NpwpVerificationBloc(
        npwpVerificationUc: sl(),
      ));
  sl.registerFactory(() => BankAccountBloc(
        bankAccountUc: sl(),
      ));
  sl.registerFactory(() => LivenessBloc(
        generateLivenessUrlUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => CameraCubit());
  sl.registerFactory(() => KtpValidationCubit());
  sl.registerFactory(() => NpwpVerificationValidationCubit());
  sl.registerFactory(() => BankAccountValidationCubit());
}
