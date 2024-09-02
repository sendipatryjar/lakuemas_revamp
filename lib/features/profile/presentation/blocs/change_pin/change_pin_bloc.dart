import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/change_pin_uc.dart';

part 'change_pin_event.dart';
part 'change_pin_state.dart';

class ChangePinBloc extends Bloc<ChangePinEvent, ChangePinState> {
  final ChangePinUc changePinUc;
  ChangePinBloc({required this.changePinUc}) : super(ChangePinInitialState()) {
    on<ChangePinPressed>((event, emit) async {
      emit(ChangePinLoadingState());
      final result = await changePinUc(ChangePinParams(
        oldPin: event.oldPin,
        newPin: event.newPin,
        newPinConfirmation: event.newPinConfirmation,
      ));
      result.fold(
        (l) => emit(ChangePinFailureState(l, l.code, l.messages)),
        (r) => emit(ChangePinSuccessState()),
      );
    });
  }
}
