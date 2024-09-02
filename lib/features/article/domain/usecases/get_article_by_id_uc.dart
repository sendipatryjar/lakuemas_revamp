import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/article_entity.dart';
import '../repositories/i_article_repository.dart';

class GetArticleByIdUc {
  final IArticleRepository repository;

  GetArticleByIdUc({required this.repository});

  Future<Either<AppFailure, ArticleEntity>> call({int? id}) =>
      repository.getArticleById(id: id);
}
