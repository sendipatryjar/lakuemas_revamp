import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/validation_utils.dart';

part 'register_validation_state.dart';

class RegisterValidationCubit extends Cubit<RegisterValidationState> {
  RegisterValidationCubit() : super(const RegisterValidationState());

  bool get isValid {
    return (state.isFullNameError == false) &&
        (state.isPhoneError == false) &&
        (state.isEmailError == false) &&
        (state.isPasswordError == false);
  }

  void validate({
    required AppLocalizations t,
    String? fullname,
    String? phoneNumber,
    String? email,
    String? password,
  }) {
    validateFullName(t: t, value: fullname);
    validatePhoneNumber(t: t, value: phoneNumber);
    validateEmail(t: t, value: email);
    validatePasword(t: t, value: password);
  }

  void validateFullName({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isFullNameError: true,
        fullNameErrorMessages: 'Nama ${t.lblCantBeEmpty}',
      ));
      return;
    }
    if ((value ?? '').length < 3) {
      emit(state.copyWith(
        isFullNameError: true,
        fullNameErrorMessages: 'nama lengkap minimal 3 karakter',
      ));
      return;
    }
    emit(state.copyWith(
      isFullNameError: false,
      fullNameErrorMessages: '',
    ));
  }

  void validatePhoneNumber({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isPhoneError: true,
        phoneErrorMessages: '${t.lblPhoneNumber} ${t.lblCantBeEmpty}',
      ));
      return;
    }
    bool isValid = ValidationUtils.mobilePhone(value ?? '');
    if (isValid == false) {
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

  void updateTermsConditions(bool value) =>
      emit(state.copyWith(isTermsConditionsChecked: value));

  void updatePrivacyPolicy(bool value) =>
      emit(state.copyWith(isPrivacyPolicyChecked: value));

  void validateEmail({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isEmailError: true,
        emailErrorMessages: '${t.lblEmail} ${t.lblCantBeEmpty}',
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

  void validatePasword({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isPasswordError: true,
        passwordErrorMessages: '${t.lblPassword} ${t.lblCantBeEmpty}',
      ));
      return;
    }
    if (ValidationUtils.password(value ?? '') == false) {
      emit(state.copyWith(
        isPasswordError: true,
        passwordErrorMessages: t.lblPasswordValidation,
      ));
      return;
    }
    emit(state.copyWith(
      isPasswordError: false,
      passwordErrorMessages: '',
    ));
  }
}
