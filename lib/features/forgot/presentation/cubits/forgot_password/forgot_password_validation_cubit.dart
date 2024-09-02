import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/validation_utils.dart';

part 'forgot_password_validation_state.dart';

class ForgotPasswordValidationCubit
    extends Cubit<ForgotPasswordValidationState> {
  ForgotPasswordValidationCubit()
      : super(const ForgotPasswordValidationState());

  bool get isValidated => state.isEmailError == false;
  bool get isValidatedPhone => state.isPhoneError == false;
  bool get isValidatedPassword =>
      state.newPasswordErrorMessage == null &&
      state.confirmPasswordErrorMessage == null;

  void validate({required AppLocalizations t, required String email}) {
    validateEmail(t: t, value: email);
    validatePhone(t: t, value: email);
  }

  String? validateNewPassword({String? password}) {
    if ((password ?? '').isEmpty) {
      emit(state.copyWith(
        nullifyNewPasswordErrorMessage: (password ?? '').isNotEmpty,
        newPasswordErrorMessage: 'Kata sandi tidak boleh kosong',
      ));
      return null;
    }
    bool isPasswordValid = ValidationUtils.password(password ?? '');
    if (isPasswordValid == false) {
      emit(state.copyWith(
        nullifyNewPasswordErrorMessage: isPasswordValid,
        newPasswordErrorMessage: 'Kata sandi minimal 6 digit',
      ));
      return null;
    }
    emit(state.copyWith(
      nullifyNewPasswordErrorMessage: true,
    ));
    return password;
  }

  String? validateConfirmPassword({String? password}) {
    if ((password ?? '').isEmpty) {
      emit(state.copyWith(
        nullifyConfirmPasswordErrorMessage: (password ?? '').isNotEmpty,
        confirmPasswordErrorMessage: 'Kata sandi tidak boleh kosong',
      ));
      return null;
    }
    bool isPasswordValid = ValidationUtils.password(password ?? '');
    if (isPasswordValid == false) {
      emit(state.copyWith(
        nullifyConfirmPasswordErrorMessage: isPasswordValid,
        confirmPasswordErrorMessage: 'Kata sandi minimal 6 digit',
      ));
      return null;
    }
    emit(state.copyWith(
      nullifyConfirmPasswordErrorMessage: true,
    ));
    return password;
  }

  void validatePassword({String? password, String? confirmPassword}) {
    String? newPasswordHelper = validateNewPassword(password: password);
    String? confirmPasswordHelper =
        validateConfirmPassword(password: confirmPassword);
    if (newPasswordHelper == confirmPasswordHelper) {
      emit(state.copyWith(
        nullifyNewPasswordErrorMessage: true,
        nullifyConfirmPasswordErrorMessage: true,
      ));
      return;
    } else {
      emit(state.copyWith(
        newPasswordErrorMessage: 'Kata sandi harus sama',
        confirmPasswordErrorMessage: 'Kata sandi harus sama',
      ));
    }
  }

  // void validatePassword({String? password, String? confirmPassword}) {
  //   if ((password ?? '').isEmpty || (confirmPassword ?? '').isEmpty) {
  //     emit(state.copyWith(
  //       nullifyNewPasswordErrorMessage: (password ?? '').isNotEmpty,
  //       newPasswordErrorMessage: 'Kata sandi tidak boleh kosong',
  //       nullifyConfirmPasswordErrorMessage: (confirmPassword ?? '').isNotEmpty,
  //       confirmPasswordErrorMessage: 'Kata sandi tidak boleh kosong',
  //     ));
  //     return;
  //   }
  //   bool isNewPasswordValid = ValidationUtils.password(password ?? '');
  //   bool isConfirmPasswordValid =
  //       ValidationUtils.password(confirmPassword ?? '');
  //   emit(state.copyWith(
  //     nullifyNewPasswordErrorMessage: isNewPasswordValid,
  //     newPasswordErrorMessage: 'Kata sandi minimal 6 digit',
  //     nullifyConfirmPasswordErrorMessage: isConfirmPasswordValid,
  //     confirmPasswordErrorMessage: 'Kata sandi minimal 6 digit',
  //   ));
  //   if (isNewPasswordValid == false && isConfirmPasswordValid == false) {
  //     return;
  //   }
  //   // if (isNewPasswordValid || isConfirmPasswordValid) {
  //   //   emit(state.copyWith(
  //   //     nullifyNewPasswordErrorMessage: isNewPasswordValid,
  //   //     newPasswordErrorMessage: 'Kata sandi minimal 6 digit',
  //   //     nullifyConfirmPasswordErrorMessage: isConfirmPasswordValid,
  //   //     confirmPasswordErrorMessage: 'Kata sandi minimal 6 digit',
  //   //   ));
  //   //   return;
  //   // }
  //   if (password == confirmPassword) {
  //     emit(state.copyWith(
  //       nullifyNewPasswordErrorMessage: true,
  //       nullifyConfirmPasswordErrorMessage: true,
  //     ));
  //     return;
  //   } else {
  //     emit(state.copyWith(
  //       newPasswordErrorMessage: 'Kata sandi harus sama',
  //       confirmPasswordErrorMessage: 'Kata sandi harus sama',
  //     ));
  //   }
  // }

  void validateEmail({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isEmailError: true,
        emailErrorMessages: t.lblCantBeEmpty,
      ));
      return;
    }
    if (ValidationUtils.email(value ?? '') == false) {
      emit(state.copyWith(
        isEmailError: true,
        emailErrorMessages: t.lblEmailError,
      ));
      return;
    }
    emit(state.copyWith(
      isEmailError: false,
      emailErrorMessages: '',
    ));
  }

  void validatePhone({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isPhoneError: true,
        phoneErrorMessages: t.lblCantBeEmpty,
      ));
      return;
    }
    if (ValidationUtils.mobilePhone(value ?? '') == false) {
      emit(state.copyWith(
        isPhoneError: true,
        phoneErrorMessages: t.lblPhoneNumberError,
      ));
      return;
    }
    emit(state.copyWith(
      isPhoneError: false,
      phoneErrorMessages: '',
    ));
  }
}
