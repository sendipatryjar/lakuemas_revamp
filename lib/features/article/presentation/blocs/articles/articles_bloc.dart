import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/models/data_with_meta.dart';
import '../../../domain/entities/article_entity.dart';
import '../../../domain/usecases/get_articles_uc.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final GetArticlesUc getArticlesUc;

  ArticlesBloc({required this.getArticlesUc}) : super(ArticlesInitialState()) {
    on<ArticlesGetEvent>((event, emit) async {
      emit(ArticlesLoadingState());
      final result = await getArticlesUc(
        limit: event.limit,
        page: event.page,
      );
      result.fold(
        (l) => emit(ArticlesFailureState(l, l.code, l.messages)),
        (r) {
          var data =
              r.data.where((element) => element.isActive == true).toList();
          List<ArticleEntity> topThree = event.topThreeNewArticle;
          List<ArticleEntity> others = data.toList();
          if (r.meta?.page == 1) {
            topThree = data.getRange(0, 3).toList();
            others = data.skip(3).toList();
          }
          emit(ArticlesSuccessState(
            metaData: r.meta,
            topThreeArticles: topThree,
            otherArticles: others,
            allArticles: data,
          ));
        },
      );
    });
  }
}
