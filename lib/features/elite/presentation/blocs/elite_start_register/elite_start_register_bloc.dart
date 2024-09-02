import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/elite_uc.dart';

part 'elite_start_register_event.dart';
part 'elite_start_register_state.dart';

class EliteStartRegisterBloc
    extends Bloc<EliteStartRegisterEvent, EliteStartRegisterState> {
  final EliteStartRegisterUc eliteStartRegisterUc;

  EliteStartRegisterBloc({required this.eliteStartRegisterUc})
      : super(EliteStartRegisterInitial()) {
    on<EliteStartRegisterEvents>((event, emit) async {
      emit(EliteStartRegisterLoadingState());
      final result = await eliteStartRegisterUc();
      result.fold(
        (l) => emit(EliteStartRegisterFailureState(l, l.code, l.messages)),
        (r) => emit(EliteStartRegisterSuccessState()),
      );
    });
  }
}
