import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/forgot_password_uc.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUc forgotPasswordUc;
  ForgotPasswordBloc({
    required this.forgotPasswordUc,
  }) : super(ForgotPasswordInitialState()) {
    on<ForgotPasswordPressedEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      final result = await forgotPasswordUc(
        event.newPassword,
        event.confirmPassword,
      );
      result.fold(
        (l) => emit(ForgotPasswordFailureState(l, l.code, l.messages)),
        (r) => emit(ForgotPasswordSuccessState()),
      );
    });
  }
}
