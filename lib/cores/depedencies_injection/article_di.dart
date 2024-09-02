import '../../features/article/data/data_sources/article_remote_data_source.dart';
import '../../features/article/data/data_sources/interfaces/i_article_remote_data_source.dart';
import '../../features/article/data/repositories/article_repository.dart';
import '../../features/article/domain/repositories/i_article_repository.dart';
import '../../features/article/domain/usecases/get_article_by_id_uc.dart';
import '../../features/article/domain/usecases/get_articles_uc.dart';
import '../../features/article/presentation/blocs/article_detail/article_detail_bloc.dart';
import '../../features/article/presentation/blocs/articles/articles_bloc.dart';
import '../../features/article/presentation/cubits/article_helper/article_helper_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IArticleRemoteDataSource>(
      () => ArticleRemoteDataSource(apiService: sl()));

  //! repositories
  sl.registerFactory<IArticleRepository>(() => ArticleRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetArticlesUc(repository: sl()));
  sl.registerFactory(() => GetArticleByIdUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => ArticlesBloc(getArticlesUc: sl()));
  sl.registerFactory(() => ArticleDetailBloc(getArticleByIdUc: sl()));

  //! cubit
  sl.registerFactory(() => ArticleHelperCubit());
}
