import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'get_terms_conditions_event.dart';
part 'get_terms_conditions_state.dart';

class GetTermsConditionsBloc
    extends Bloc<GetTermsConditionsEvent, GetTermsConditionsState> {
  final GetTermsConditionsUc getTermsConditionsUc;
  GetTermsConditionsBloc({required this.getTermsConditionsUc})
      : super(GetTermsConditionsInitial()) {
    on<GetTermsConditionsEvents>((event, emit) async {
      emit(GetTermsConditionsLoadingState());
      final result = await getTermsConditionsUc();
      result.fold(
        (l) => emit(GetTermsConditionsFailureState(l, l.code, l.messages)),
        (r) => emit(GetTermsConditionsSuccessState(r)),
      );
    });
  }
}
