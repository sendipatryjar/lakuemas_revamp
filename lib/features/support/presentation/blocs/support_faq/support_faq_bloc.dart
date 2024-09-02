import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/support_faq_entity.dart';
import '../../../domain/usecases/get_faq_support_uc.dart';

part 'support_faq_event.dart';
part 'support_faq_state.dart';

class SupportFaqBloc extends Bloc<SupportFaqEvent, SupportFaqState> {
  final GetFaqSupportUc getfaqSupportUc;

  SupportFaqBloc({required this.getfaqSupportUc})
      : super(SupportFaqInitialState()) {
    on<SupportFaqGetEvent>((event, emit) async {
      emit(SupportFaqLoadingState());
      final result = await getfaqSupportUc(keyword: event.keyword);
      result.fold(
        (l) => emit(SupportFaqFailureState(l, l.code, l.messages)),
        (r) => emit(SupportFaqSuccessState(data: r)),
      );
    });
  }
}
