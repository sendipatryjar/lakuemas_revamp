import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/i_article_repository.dart';
import '../data_sources/interfaces/i_article_remote_data_source.dart';

class ArticleRepository implements IArticleRepository {
  final IArticleRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  ArticleRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, DataWithMeta<List<ArticleEntity>>>> getArticles(
      {int? limit, int? page, String? orderBy, String? sortBy}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getArticles(
          accessToken: accessToken,
          refreshToken: refreshToken,
          limit: limit,
          page: page,
          orderBy: orderBy,
          sortBy: sortBy,
        );
        return Right(DataWithMeta<List<ArticleEntity>>(
            result.data ?? [], result.meta ?? {}));
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(
          code: e.code,
          messages: e.toString(),
          errors: e.errors,
        ));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getArticles][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, ArticleEntity>> getArticleById({int? id}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getArticleById(
          accessToken: accessToken,
          refreshToken: refreshToken,
          id: id,
        );
        return Right(result.data!);
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(
          code: e.code,
          messages: e.toString(),
          errors: e.errors,
        ));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getArticleById][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
