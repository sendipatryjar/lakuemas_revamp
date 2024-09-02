import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../article/domain/entities/article_entity.dart';
import '../../../domain/usecases/get_articles_uc.dart';

part 'beranda_articles_event.dart';
part 'beranda_articles_state.dart';

class BerandaArticlesBloc extends Bloc<BerandaArticlesEvent, BerandaArticlesState> {
  final BerandaGetArticlesUc getArticlesUc;

  BerandaArticlesBloc({required this.getArticlesUc}) : super(BerandaArticlesInitialState()) {
    on<BerandaArticlesGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.articles.isNotEmpty) {
        var data = event.helperDataCubit.state.articles.where((element) => element.isActive == true).toList();
        emit(BerandaArticlesSuccessState(
          articles: data,
        ));
        return;
      }
      emit(BerandaArticlesLoadingState());
      final result = await getArticlesUc();
      result.fold(
        (l) => emit(BerandaArticlesFailureState(l, l.code, l.messages)),
        (r) {
          var data = r.where((element) => element.isActive == true).toList();
          event.helperDataCubit.updateArticle(data);
          emit(BerandaArticlesSuccessState(articles: data));
        },
      );
    });
  }
}
