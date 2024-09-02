import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/validation_utils.dart';

part 'change_password_validation_state.dart';

class ChangePasswordValidationCubit
    extends Cubit<ChangePasswordValidationState> {
  ChangePasswordValidationCubit()
      : super(const ChangePasswordValidationState());

  bool get isValidated {
    return (state.oldPasswordError ?? '').isEmpty &&
        (state.newPasswordError ?? '').isEmpty &&
        (state.newPasswordConfirmError ?? '').isEmpty;
  }

  void validate(
    AppLocalizations t,
    String? oldPassword,
    String? newPassword,
    String? newPasswordConfirm,
  ) {
    bool isOldPasswordValidated = ValidationUtils.password(oldPassword ?? '');
    if (isOldPasswordValidated != true) {
      emit(state.copyWith(oldPasswordError: t.lblPasswordValidation));
    } else {
      emit(state.copyWith(oldPasswordError: ''));
    }
    bool isNewPasswordValidated = ValidationUtils.password(newPassword ?? '');
    if (isNewPasswordValidated != true) {
      emit(state.copyWith(newPasswordError: t.lblPasswordValidation));
    } else {
      emit(state.copyWith(newPasswordError: ''));
    }
    if (newPassword != newPasswordConfirm) {
      emit(state.copyWith(
          newPasswordConfirmError: '${t.lblPassword} ${t.lblNotMatch}'));
    } else {
      emit(state.copyWith(newPasswordConfirmError: ''));
    }
    // Validasi kata sandi baru tidak boleh sama dengan kata sandi lama
    if (newPassword == oldPassword) {
      emit(
        state.copyWith(
          newPasswordError: t.lblDontSameOldPass,
        ),
      );
    } else {
      emit(state.copyWith(newPasswordError: ''));
    }

    if (newPasswordConfirm == oldPassword) {
      emit(
        state.copyWith(
          newPasswordConfirmError: t.lblDontSameOldPass,
        ),
      );
    } else {
      emit(state.copyWith(newPasswordConfirmError: ''));
    }
  }

  void validateOldPassword(
    AppLocalizations t,
    String? oldPassword,
  ) {
    if ((oldPassword ?? '').isEmpty) {
      emit(state.copyWith(
          oldPasswordError: '${t.lblOldPassword} ${t.lblCantBeEmpty}'));
      return;
    }
    emit(state.copyWith(oldPasswordError: ''));
    bool isOldPasswordValidated = ValidationUtils.password(oldPassword ?? '');
    if (isOldPasswordValidated != true) {
      emit(state.copyWith(oldPasswordError: t.lblPasswordValidation));
      return;
    }
  }

  void validateNewPassword(
    AppLocalizations t,
    String? newPassword,
  ) {
    bool isNewPasswordValidated = ValidationUtils.password(newPassword ?? '');
    if (isNewPasswordValidated != true) {
      emit(state.copyWith(newPasswordError: t.lblPasswordValidation));
      return;
    }
    emit(state.copyWith(newPasswordError: ''));
  }

  void validateConfirmPassword(
    AppLocalizations t,
    String? newPassword,
    String? newPasswordConfirm,
  ) {
    if ((newPasswordConfirm ?? "").isNotEmpty &&
        newPassword != newPasswordConfirm) {
      emit(state.copyWith(
          newPasswordConfirmError: '${t.lblPassword} ${t.lblNotMatch}'));
      return;
    }
    emit(state.copyWith(newPasswordConfirmError: ''));
  }
}
