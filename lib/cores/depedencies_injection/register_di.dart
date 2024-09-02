import '../../features/register/data/data_source/interfaces/i_register_remote_data_source.dart';
import '../../features/register/data/data_source/register_remote_data_source.dart';
import '../../features/register/data/repositories/register_repository.dart';
import '../../features/register/domain/repositories/i_register_repository.dart';
import '../../features/register/domain/usecases/get_privacy_policy_register_uc.dart';
import '../../features/register/domain/usecases/get_terms_and_conditions_register_uc.dart';
import '../../features/register/domain/usecases/register_uc.dart';
import '../../features/register/presentation/blocs/pivacy_policy_register/privacy_policy_register_bloc.dart';
import '../../features/register/presentation/blocs/register/register_bloc.dart';
import '../../features/register/presentation/blocs/t_and_c_register/t_and_c_register_bloc.dart';
import '../../features/register/presentation/cubits/register_validation/register_validation_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IRegisterRemoteDataSource>(() => RegisterRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<IRegisterRepository>(() => RegisterRepository(
        remoteDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => RegisterUc(
        repo: sl(),
      ));
  sl.registerFactory(() => GetTermsAndConditionsRegisterUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetPrivacyPolicyRegisterUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => RegisterBloc(
        registerUc: sl(),
      ));
  sl.registerFactory(() => TAndCRegisterBloc(
        getTermsAndConditionsRegisterUc: sl(),
      ));
  sl.registerFactory(() => PrivacyPolicyRegisterBloc(
        getPrivacyPolicyRegisterUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => RegisterValidationCubit());
}
