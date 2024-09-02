import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/models/data_with_meta.dart';
import '../../../domain/entities/article_entity.dart';

part 'article_helper_state.dart';

class ArticleHelperCubit extends Cubit<ArticleHelperState> {
  ArticleHelperCubit() : super(const ArticleHelperState());

  void updateLoadingTrue() => emit(state.copyWith(isLoading: true));

  void updateErrorTrue() => emit(state.copyWith(isError: true));

  void updateArticles({
    required int page,
    required List<ArticleEntity> topThreeArticles,
    required List<ArticleEntity> articles,
    required MetaDataApi? metaData,
  }) {
    List<ArticleEntity> data = [];
    data.addAll(state.articles);
    data.addAll(articles);
    emit(state.copyWith(
      topThreeArticles: topThreeArticles,
      articles: data,
      isLoading: false,
      isError: false,
      meta: metaData,
    ));
  }
}
