import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/dice_gatcha_uc.dart';

part 'dice_gatcha_event.dart';
part 'dice_gatcha_state.dart';

class DiceGatchaBloc extends Bloc<DiceGatchaEvent, DiceGatchaState> {
  final DiceGatchaUc diceGatchaUc;

  DiceGatchaBloc({required this.diceGatchaUc}) : super(DiceGatchaInitialState()) {
    on<DiceGatchaDoNowEvent>((event, emit) async {
      emit(DiceGatchaLoadingState());
      final result = await diceGatchaUc(qty: event.qty);
      result.fold(
        (l) {
          if (event.reHitCount >= 3) {
            l = const ClientFailure(
                code: 400, messages: "terjadi kesalahan...", errors: {"fl": "terjadi kesalahan..."});
          }
          emit(DiceGatchaFailureState(l, l.code, l.messages));
        },
        (r) => emit(const DiceGatchaSuccessState()),
      );
    });
  }
}
