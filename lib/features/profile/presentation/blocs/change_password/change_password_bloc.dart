import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/change_password_uc.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUc changePasswordUc;
  ChangePasswordBloc({required this.changePasswordUc})
      : super(ChangePasswordInitialState()) {
    on<ChangePasswordPressed>((event, emit) async {
      emit(ChangePasswordLoadingState());
      final result = await changePasswordUc(ChangePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
        newPasswordConfirmation: event.newPasswordConfirmation,
      ));
      result.fold(
        (l) => emit(ChangePasswordFailureState(l, l.code, l.messages)),
        (r) => emit(ChangePasswordSuccessState()),
      );
    });
  }
}
