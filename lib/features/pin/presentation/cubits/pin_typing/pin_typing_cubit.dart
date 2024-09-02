import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pin_typing_state.dart';

class PinTypingCubit extends Cubit<PinTypingState> {
  PinTypingCubit()
      : super(const PinTypingState(pinStateEn: PinStateEn.typed, pin: ''));

  int get pinLength => 6;

  void add(int? value) async {
    if (state.pin.length < pinLength) {
      var pin = '${state.pin}$value';
      emit(state.copyWith(pinStateEn: PinStateEn.typed, pin: pin));
    }
    if (state.pin.length >= pinLength) {
      emit(state.copyWith(pinStateEn: PinStateEn.submited));
    }
  }

  void erase({bool isDeleteAll = false}) {
    if (state.pin.isNotEmpty) {
      if (isDeleteAll == true) {
        emit(state.copyWith(pinStateEn: PinStateEn.typed, pin: ''));
        return;
      }
      String pin = state.pin.substring(0, state.pin.length - 1);
      emit(state.copyWith(pinStateEn: PinStateEn.typed, pin: pin));
    }
  }
}
