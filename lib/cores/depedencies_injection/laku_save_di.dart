import '../../features/laku_save/data/data_sources/interfaces/i_lakusave_remote_data_source.dart';
import '../../features/laku_save/data/data_sources/lakusave_remote_data_source.dart';
import '../../features/laku_save/data/repositories/lakusave_repository.dart';
import '../../features/laku_save/domain/repositories/i_lakusave_repoisitory.dart';
import '../../features/laku_save/domain/usecases/get_about_uc.dart';
import '../../features/laku_save/domain/usecases/get_master_data_lakusave_uc.dart';
import '../../features/laku_save/domain/usecases/lakusave_cancel_uc.dart';
import '../../features/laku_save/domain/usecases/lakusave_checkout_uc.dart';
import '../../features/laku_save/domain/usecases/lakusave_get_transactions_uc.dart';
import '../../features/laku_save/domain/usecases/lakusave_update_extend_uc.dart';
import '../../features/laku_save/presentation/blocs/lakusave/lakusave_bloc.dart';
import '../../features/laku_save/presentation/blocs/lakusave_about/lakusave_about_bloc.dart';
import '../../features/laku_save/presentation/blocs/lakusave_cancel/lakusave_cancel_bloc.dart';
import '../../features/laku_save/presentation/blocs/lakusave_checkout/lakusave_checkout_bloc.dart';
import '../../features/laku_save/presentation/blocs/lakusave_update_extend/lakusave_update_extend_bloc.dart';
import '../../features/laku_save/presentation/blocs/master_data/master_data_lakusave_bloc.dart';
import '../../features/laku_save/presentation/cubits/laku_save_terms_condition/laku_save_terms_condition_cubit.dart';
import '../../features/laku_save/presentation/cubits/lakusave/lakusave_cubit.dart';
import '../../features/laku_save/presentation/cubits/lakusave_auto_extended/lakusave_auto_extended_cubit.dart';
import '../../features/laku_save/presentation/cubits/lakusave_update_extend/lakusave_update_extend_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ILakusaveRemoteDataSource>(() => LakusaveRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<ILakusaveRepository>(() => LakusaveRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => LakusaveGetTransactionsUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetMasterDataLakusaveUc(
        repository: sl(),
      ));
  sl.registerFactory(() => LakusaveCheckoutUc(
        repository: sl(),
      ));
  sl.registerFactory(() => LakusaveCancelUc(
        repository: sl(),
      ));
  sl.registerFactory(() => LakusaveUpdateExtendUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetAboutUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => LakusaveBloc(
        getTransactionsUc: sl(),
      ));
  sl.registerFactory(() => MasterDataLakusaveBloc(
        getMasterDataLakusaveUc: sl(),
      ));
  sl.registerFactory(() => LakusaveCheckoutBloc(
        lakusaveCheckoutUc: sl(),
      ));
  sl.registerFactory(() => LakusaveCancelBloc(
        lakusaveCancelUc: sl(),
      ));
  sl.registerFactory(() => LakusaveUpdateExtendBloc(
        lakusaveUpdateExtendUc: sl(),
      ));
  sl.registerFactory(() => LakusaveAboutBloc(
        getAboutUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => LakusaveCubit());
  sl.registerFactory(() => LakuSaveTermsConditionCubit());
  sl.registerFactory(() => LakusaveAutoExtendedCubit());
  sl.registerFactory(() => LakusaveUpdateExtendCubit());
}
