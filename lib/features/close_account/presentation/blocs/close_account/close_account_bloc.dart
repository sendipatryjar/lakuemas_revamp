import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/close_account_submit_uc.dart';

part 'close_account_event.dart';
part 'close_account_state.dart';

class CloseAccountBloc extends Bloc<CloseAccountEvent, CloseAccountState> {
  final CloseAccountSubmitUc closeAccountSubmitUc;
  CloseAccountBloc({required this.closeAccountSubmitUc})
      : super(CloseAccountInitialState()) {
    on<CloseAccountSubmitEvent>((event, emit) async {
      emit(CloseAccountLoadingState());
      final result = await closeAccountSubmitUc(event.reason);
      result.fold(
        (l) => emit(CloseAccountFailureState(l, l.code, l.messages)),
        (r) => emit(CloseAccountSuccessState()),
      );
    });
  }
}
