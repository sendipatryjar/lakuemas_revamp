import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../domain/entities/faq_entity.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'get_faq_event.dart';
part 'get_faq_state.dart';

class GetFaqBloc extends Bloc<GetFaqEvent, GetFaqState> {
  final GetFaqUc getFaqUc;
  GetFaqBloc({required this.getFaqUc}) : super(GetFaqInitial()) {
    on<GetFaqEvents>((event, emit) async {
      if (event.helperDataEliteCubit.state.faq != null) {
        emit(GetFaqSuccessState(event.helperDataEliteCubit.state.faq!));
        return;
      }
      emit(GetFaqLoadingState());
      final result = await getFaqUc(GetFaqParams(
        sortBy: event.sortBy ?? 'asc',
        orderBy: event.orderBy ?? 'id',
        isActive: event.isActive ?? 1,
      ));
      result.fold(
        (l) => emit(GetFaqFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataEliteCubit.updateFaq(r);
          emit(GetFaqSuccessState(r));
        },
      );
    });
  }
}
