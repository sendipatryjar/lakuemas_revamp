import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_obsecure_state.dart';

class ChangeObsecureCubit extends Cubit<ChangeObsecureState> {
  ChangeObsecureCubit() : super(const ChangeObsecureState());

  void changeObsOldPassword(bool oldPassword) {
    emit(state.copyWith(isOldPassword: oldPassword));
  }

  void changeObsNewPassword(bool newPassword) {
    emit(state.copyWith(isNewPassword: newPassword));
  }

  void changeObsConfirmPassword(bool confirmPassword) {
    emit(state.copyWith(isConfirmPassword: confirmPassword));
  }
}
