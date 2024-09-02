import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/create_pin_uc.dart';
import '../../../domain/usecases/validate_pin_uc.dart';

part 'pin_event.dart';
part 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  final CreatePinUc createPinUc;
  final ValidatePinUc validatePinUc;

  PinBloc({
    required this.createPinUc,
    required this.validatePinUc,
  }) : super(PinInitialState()) {
    on<PinCreateSubmitEvent>((event, emit) async {
      emit(PinLoadingState());
      final result = await createPinUc(CreatePinParams(
        pin: event.pin,
        pinConfirm: event.pinConfirmation,
      ));
      result.fold(
        (l) => emit(PinFailureState(l, l.code, l.messages, l.errors)),
        (r) => emit(PinSuccessState()),
      );
    });
    on<PinValidateEvent>((event, emit) async {
      emit(PinLoadingState());
      final result = await validatePinUc(event.pin);
      result.fold(
        (l) => emit(PinFailureState(l, l.code, l.messages, l.errors)),
        (r) => emit(PinSuccessState()),
      );
    });
    on<PinInitialFromErrorEvent>((event, emit) => emit(PinInitialState()));
  }
}
