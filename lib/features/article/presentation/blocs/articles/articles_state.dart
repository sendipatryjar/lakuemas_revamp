part of 'articles_bloc.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();

  @override
  List<Object> get props => [];
}

class ArticlesInitialState extends ArticlesState {}

class ArticlesLoadingState extends ArticlesState {}

class ArticlesSuccessState extends ArticlesState {
  final MetaDataApi? metaData;
  final List<ArticleEntity> topThreeArticles;
  final List<ArticleEntity> otherArticles;
  final List<ArticleEntity> allArticles;

  const ArticlesSuccessState({
    required this.metaData,
    required this.topThreeArticles,
    required this.otherArticles,
    required this.allArticles,
  });

  @override
  List<Object> get props => [
        [topThreeArticles, otherArticles, allArticles]
      ];
}

class ArticlesFailureState extends ArticlesState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ArticlesFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
