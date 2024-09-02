import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../domain/entities/elite_me_entity.dart';
import '../../../domain/usecases/elite_me_uc.dart';

part 'elite_me_event.dart';
part 'elite_me_state.dart';

class EliteMeBloc extends Bloc<EliteMeEvent, EliteMeState> {
  final EliteMeUc eliteMeUc;
  EliteMeBloc({required this.eliteMeUc}) : super(EliteMeInitial()) {
    on<EliteMeGetEvent>((event, emit) async {
      if (event.helperDataEliteCubit.state.eliteMeEntity != null) {
        emit(EliteMeSuccessState(
            event.helperDataEliteCubit.state.eliteMeEntity!));
        return;
      }
      emit(EliteMeLoadingState());
      final result = await eliteMeUc();
      result.fold(
        (l) => emit(EliteMeFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataEliteCubit.updateEliteMe(r);
          emit(EliteMeSuccessState(r));
        },
      );
    });
  }
}
