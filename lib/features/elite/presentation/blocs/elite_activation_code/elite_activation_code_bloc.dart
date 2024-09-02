import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/elite_activation_code_validation_entity.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'elite_activation_code_event.dart';
part 'elite_activation_code_state.dart';

class EliteActivationCodeBloc
    extends Bloc<EliteActivationCodeEvent, EliteActivationCodeState> {
  final EliteActivationCodeValidationUc eliteActivationCodeValidationUc;
  EliteActivationCodeBloc({required this.eliteActivationCodeValidationUc})
      : super(EliteActivationCodeInitial()) {
    on<EliteActivationCodeValidationEvent>((event, emit) async {
      emit(EliteActivationCodeLoadingState());
      final result = await eliteActivationCodeValidationUc(
        event.voucherCode,
        event.type,
      );
      result.fold(
        (l) => emit(EliteActivationCodeFailureState(l, l.code, l.messages)),
        (r) => emit(EliteActivationCodeSuccessState(r)),
      );
    });
  }
}
