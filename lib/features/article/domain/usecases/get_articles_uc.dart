import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../entities/article_entity.dart';
import '../repositories/i_article_repository.dart';

class GetArticlesUc {
  final IArticleRepository repository;

  GetArticlesUc({required this.repository});

  Future<Either<AppFailure, DataWithMeta<List<ArticleEntity>>>> call(
          {int? limit, int? page, String? orderBy, String? sortBy}) =>
      repository.getArticles(
        limit: limit ?? 3,
        page: page ?? 1,
        orderBy: orderBy ?? 'created_at',
        sortBy: sortBy ?? 'desc',
      );
}
