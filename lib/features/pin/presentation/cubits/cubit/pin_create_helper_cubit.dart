import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pin_create_helper_state.dart';

class PinCreateHelperCubit extends Cubit<PinCreateHelperState> {
  PinCreateHelperCubit()
      : super(const PinCreateHelperState(
          pin: '',
          pinConfirmation: '',
          pinType: 0,
        ));
  void updatePin(String pin) => emit(state.copyWith(pin: pin));
  void updatePinConfirmation(String pinConfirmation) =>
      emit(state.copyWith(pinConfirmation: pinConfirmation));
  void updatePinType(int loc) => emit(state.copyWith(pinType: loc));

  void deleteAll() => emit(state.copyWith(pin: '', pinConfirmation: ''));
}
