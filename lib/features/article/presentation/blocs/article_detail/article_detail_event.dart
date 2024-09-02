part of 'article_detail_bloc.dart';

sealed class ArticleDetailEvent extends Equatable {
  const ArticleDetailEvent();

  @override
  List<Object> get props => [];
}

class ArticleDetailGetEvent extends ArticleDetailEvent {
  final int? id;

  const ArticleDetailGetEvent(this.id);

  @override
  List<Object> get props => [
        [id]
      ];
}
