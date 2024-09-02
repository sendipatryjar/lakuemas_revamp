import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/article_entity.dart';
import '../../../domain/usecases/get_article_by_id_uc.dart';

part 'article_detail_event.dart';
part 'article_detail_state.dart';

class ArticleDetailBloc extends Bloc<ArticleDetailEvent, ArticleDetailState> {
  final GetArticleByIdUc getArticleByIdUc;

  ArticleDetailBloc({required this.getArticleByIdUc})
      : super(ArticleDetailInitialState()) {
    on<ArticleDetailGetEvent>((event, emit) async {
      emit(ArticleDetailLoadingState());
      final result = await getArticleByIdUc(id: event.id);
      result.fold(
        (l) => emit(ArticleDetailFailureState(l, l.code, l.messages)),
        (r) => emit(ArticleDetailSuccessState(article: r)),
      );
    });
  }
}
