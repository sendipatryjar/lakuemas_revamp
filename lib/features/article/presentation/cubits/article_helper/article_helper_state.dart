part of 'article_helper_cubit.dart';

class ArticleHelperState extends Equatable {
  final List<ArticleEntity> topThreeArticles;
  final List<ArticleEntity> articles;
  final bool isLoading;
  final bool isError;
  final MetaDataApi? meta;

  const ArticleHelperState({
    this.topThreeArticles = const [],
    this.articles = const [],
    this.isLoading = false,
    this.isError = false,
    this.meta,
  });

  ArticleHelperState copyWith({
    List<ArticleEntity>? topThreeArticles,
    List<ArticleEntity>? articles,
    bool? isLoading,
    bool? isError,
    MetaDataApi? meta,
  }) =>
      ArticleHelperState(
        topThreeArticles: topThreeArticles ?? this.topThreeArticles,
        articles: articles ?? this.articles,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        meta: meta ?? this.meta,
      );

  @override
  List<Object> get props => [
        [
          topThreeArticles,
          articles,
          isLoading,
          isError,
          meta,
        ]
      ];
}
