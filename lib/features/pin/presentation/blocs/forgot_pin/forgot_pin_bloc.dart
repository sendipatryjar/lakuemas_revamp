import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/forgot_pin_uc.dart';

part 'forgot_pin_event.dart';
part 'forgot_pin_state.dart';

class ForgotPinBloc extends Bloc<ForgotPinEvent, ForgotPinState> {
  final ForgotPinUc forgotPinUc;

  ForgotPinBloc({required this.forgotPinUc}) : super(ForgotPinInitialState()) {
    on<ForgotPinPressedEvent>((event, emit) async {
      emit(ForgotPinLoadingState());
      final result = await forgotPinUc(
        event.newPin,
        event.confirmPin,
      );
      result.fold(
        (l) => emit(ForgotPinFailureState(l, l.code, l.messages)),
        (r) => emit(ForgotPinSuccessState()),
      );
    });
  }
}
