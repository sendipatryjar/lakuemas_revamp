import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/validation_utils.dart';

part 'change_username_validation_state.dart';

class ChangeUsernameValidationCubit
    extends Cubit<ChangeUsernameValidationState> {
  ChangeUsernameValidationCubit()
      : super(const ChangeUsernameValidationState());

  bool isPhoneValidated() =>
      (state.phoneNumber ?? "").isNotEmpty && state.phoneNumberError == null;

  void validatePhoneNumber(
      AppLocalizations t, String? oldPhoneNumber, String? phoneNumber) {
    if ((phoneNumber ?? "").isEmpty) {
      emit(state.copyWith(
          phoneNumber: phoneNumber, phoneNumberError: t.lblCantBeEmpty));
      return;
    }
    bool isValid = ValidationUtils.mobilePhone(phoneNumber ?? "");
    if (isValid == false) {
      emit(state.copyWith(
          phoneNumber: phoneNumber, phoneNumberError: t.lblPhoneNumberError));
      return;
    }
    if (oldPhoneNumber == phoneNumber) {
      emit(state.copyWith(
          phoneNumber: phoneNumber,
          phoneNumberError: "nomor ponsel tidak berubah"));
      return;
    }
    emit(state.copyWith(
        phoneNumber: phoneNumber, nullifyPhoneNumberError: true));
  }
}
