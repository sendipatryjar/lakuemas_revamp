import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/validation_utils.dart';

part 'forgot_pin_validation_state.dart';

class ForgotPinValidationCubit extends Cubit<ForgotPinValidationState> {
  ForgotPinValidationCubit() : super(const ForgotPinValidationState());

  bool get isValidated => state.isEmailError == false;
  bool get isValidatedPhone => state.isPhoneError == false;
  bool get isValidatedPin => state.isPinError == false;

  void validate({required AppLocalizations t, required String email}) {
    _validateEmail(t: t, value: email);
    _validatePhone(t: t, value: email);
  }

  void validatePin(String pin, String confirmPin) {
    if ((pin).isEmpty || (confirmPin).isEmpty) {
      emit(state.copyWith(
        isPinError: true,
        isPinNotSame: 'PIN tidak boleh kosong',
      ));
      return;
    }
    if (ValidationUtils.pin(pin) == false &&
        ValidationUtils.pin(confirmPin) == false) {
      emit(state.copyWith(
        isPinError: true,
        isPinNotSame: 'PIN harus memiliki panjang 6 karakter',
      ));
      return;
    }
    if (pin == confirmPin) {
      emit(state.copyWith(
        isPinError: false,
      ));
      return;
    } else {
      emit(state.copyWith(
        isPinError: true,
        isPinNotSame: 'PIN harus sama',
      ));
      return;
    }
  }

  void _validateEmail({required AppLocalizations t, String? value}) {
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

  void _validatePhone({required AppLocalizations t, String? value}) {
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
