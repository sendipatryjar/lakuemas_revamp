import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/lakusave_cancel_uc.dart';

part 'lakusave_cancel_event.dart';
part 'lakusave_cancel_state.dart';

class LakusaveCancelBloc extends Bloc<LakusaveCancelEvent, LakusaveCancelState> {
  final LakusaveCancelUc lakusaveCancelUc;
  LakusaveCancelBloc({required this.lakusaveCancelUc}) : super(LakusaveCancelInitialState()) {
    on<LakusaveCancelDoItEvent>((event, emit) async {
      emit(LakusaveCancelLoadingState());
      final result = await lakusaveCancelUc(transactionCode: event.transactionCode);
      result.fold(
        (l) => emit(LakusaveCancelFailureState(l, l.code, l.messages)),
        (r) => emit(LakusaveCancelSuccessState()),
      );
    });
    on<LakusaveCancelInitEvent>(
      (event, emit) => emit(LakusaveCancelInitialState()),
    );
  }
}
