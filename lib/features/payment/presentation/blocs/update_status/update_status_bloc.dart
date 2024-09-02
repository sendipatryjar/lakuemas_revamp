import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/update_status_entity.dart';
import '../../../domain/usecases/update_status_uc.dart';

part 'update_status_event.dart';
part 'update_status_state.dart';

class UpdateStatusBloc extends Bloc<UpdateStatusEvent, UpdateStatusState> {
  final UpdateStatusUc updateStatusUc;

  UpdateStatusBloc({required this.updateStatusUc})
      : super(UpdateStatusInitialState()) {
    on<UpdateStatusPressedEvent>((event, emit) async {
      emit(UpdateStatusLoadingState());
      final result = await updateStatusUc(event.trxCode);
      result.fold(
        (l) => emit(UpdateStatusFailureState(l, l.code, l.messages)),
        (r) => emit(UpdateStatusSuccessState(r)),
      );
    });
  }
}
