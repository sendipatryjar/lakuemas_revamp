part of 'beranda_articles_bloc.dart';

abstract class BerandaArticlesState extends Equatable {
  const BerandaArticlesState();

  @override
  List<Object> get props => [];
}

class BerandaArticlesInitialState extends BerandaArticlesState {}

class BerandaArticlesLoadingState extends BerandaArticlesState {}

class BerandaArticlesSuccessState extends BerandaArticlesState {
  final List<ArticleEntity> articles;

  const BerandaArticlesSuccessState({
    required this.articles,
  });

  @override
  List<Object> get props => [
        [articles]
      ];
}

class BerandaArticlesFailureState extends BerandaArticlesState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const BerandaArticlesFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}
