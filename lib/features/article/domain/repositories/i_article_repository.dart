import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../entities/article_entity.dart';

abstract class IArticleRepository {
  Future<Either<AppFailure, DataWithMeta<List<ArticleEntity>>>> getArticles({
    int? limit,
    int? page,
    String? orderBy,
    String? sortBy,
  });
  Future<Either<AppFailure, ArticleEntity>> getArticleById({
    int? id,
  });
}
