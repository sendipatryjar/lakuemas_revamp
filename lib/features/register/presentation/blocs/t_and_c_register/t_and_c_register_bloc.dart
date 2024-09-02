import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../../../domain/usecases/get_terms_and_conditions_register_uc.dart';

part 't_and_c_register_event.dart';
part 't_and_c_register_state.dart';

class TAndCRegisterBloc extends Bloc<TAndCRegisterEvent, TAndCRegisterState> {
  final GetTermsAndConditionsRegisterUc getTermsAndConditionsRegisterUc;

  TAndCRegisterBloc({required this.getTermsAndConditionsRegisterUc})
      : super(TAndCRegisterInitialState()) {
    on<TAndCRegisterGetEvent>((event, emit) async {
      emit(TAndCRegisterLoadingState());
      final result = await getTermsAndConditionsRegisterUc();
      result.fold(
        (l) => emit(TAndCRegisterFailureState(l, l.code, l.messages)),
        (r) => emit(TAndCRegisterSuccessState(tAndCRegister: r)),
      );
    });
  }
}
