part of 'articles_bloc.dart';

abstract class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object> get props => [];
}

class ArticlesGetEvent extends ArticlesEvent {
  final int? limit;
  final int? page;
  final List<ArticleEntity> topThreeNewArticle;

  const ArticlesGetEvent(
      {this.limit, this.page, this.topThreeNewArticle = const []});

  @override
  List<Object> get props => [
        [
          limit,
          page,
          topThreeNewArticle,
        ]
      ];
}
