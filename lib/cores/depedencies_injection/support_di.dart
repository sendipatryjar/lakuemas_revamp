import '../../features/support/data/data_sources/interfaces/i_support_remote_data_source.dart';
import '../../features/support/data/data_sources/support_remote_data_source.dart';
import '../../features/support/data/repositories/support_repository.dart';
import '../../features/support/domain/repositories/i_support_repository.dart';
import '../../features/support/domain/usecases/get_support_contact_uc.dart';
import '../../features/support/domain/usecases/get_faq_support_uc.dart';
import '../../features/support/presentation/blocs/support_contact/support_contact_bloc.dart';
import '../../features/support/presentation/blocs/support_faq/support_faq_bloc.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ISupportRemoteDataSource>(() => SupportRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<ISupportRepository>(() => SupportRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetFaqSupportUc(repository: sl()));
  sl.registerFactory(() => GetSupportContactUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => SupportFaqBloc(getfaqSupportUc: sl()));
  sl.registerFactory(() => SupportContactBloc(supportContactUc: sl()));

  //! cubit
}
