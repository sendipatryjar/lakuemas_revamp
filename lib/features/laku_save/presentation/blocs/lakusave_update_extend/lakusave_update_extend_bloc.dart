import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/lakusave_update_extend_uc.dart';

part 'lakusave_update_extend_event.dart';
part 'lakusave_update_extend_state.dart';

class LakusaveUpdateExtendBloc
    extends Bloc<LakusaveUpdateExtendEvent, LakusaveUpdateExtendState> {
  final LakusaveUpdateExtendUc lakusaveUpdateExtendUc;

  LakusaveUpdateExtendBloc({required this.lakusaveUpdateExtendUc})
      : super(LakusaveUpdateExtendInitialState()) {
    on<LakusaveUpdateExtendNowEvent>((event, emit) async {
      emit(LakusaveUpdateExtendLoadingState());
      final result = await lakusaveUpdateExtendUc(
        extendId: event.extendId,
        accountNumber: event.accountNumber,
      );
      result.fold(
        (l) => emit(LakusaveUpdateExtendFailureState(l, l.code, l.messages)),
        (r) => emit(LakusaveUpdateExtendSuccessState()),
      );
    });
  }
}
