import '../../features/language/data/data_sources/intefaces/i_language_local_data_source.dart';
import '../../features/language/data/data_sources/language_local_data_source.dart';
import '../../features/language/data/repositories/language_repository.dart';
import '../../features/language/domain/repositories/i_language_repository.dart';
import '../../features/language/domain/usecases/get_language_uc.dart';
import '../../features/language/domain/usecases/insert_language_uc.dart';
import '../../features/language/presentation/cubit/languages_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<ILanguageLocalDataSource>(() => LanguageLocalDataSource(
        secureStorageService: sl(),
      ));

  //! repositories
  sl.registerFactory<ILanguageRepository>(() => LanguageRepository(
        localDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => InsertLanguageUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetLanguageUc(
        repository: sl(),
      ));

  //! bloc

  //! cubit
  sl.registerFactory(() => LanguagesCubit(
        getLanguageUc: sl(),
        insertLanguageUc: sl(),
      ));
}
