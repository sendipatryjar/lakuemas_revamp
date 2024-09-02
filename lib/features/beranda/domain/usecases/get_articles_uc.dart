import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../article/domain/entities/article_entity.dart';
import '../repositories/i_beranda_repository.dart';

class BerandaGetArticlesUc {
  final IBerandaRepository repository;

  BerandaGetArticlesUc({required this.repository});

  Future<Either<AppFailure, List<ArticleEntity>>> call() => repository.getArticles(
        limit: '8',
        page: '1',
        orderBy: 'created_at',
        sortBy: 'desc',
      );
}
