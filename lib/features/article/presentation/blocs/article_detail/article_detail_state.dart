part of 'article_detail_bloc.dart';

sealed class ArticleDetailState extends Equatable {
  const ArticleDetailState();

  @override
  List<Object> get props => [];
}

class ArticleDetailInitialState extends ArticleDetailState {}

class ArticleDetailLoadingState extends ArticleDetailState {}

class ArticleDetailSuccessState extends ArticleDetailState {
  final ArticleEntity article;

  const ArticleDetailSuccessState({
    required this.article,
  });

  @override
  List<Object> get props => [
        [article]
      ];
}

class ArticleDetailFailureState extends ArticleDetailState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ArticleDetailFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
