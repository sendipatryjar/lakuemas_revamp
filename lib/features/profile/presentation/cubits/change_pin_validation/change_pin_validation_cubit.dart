import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/validation_utils.dart';

part 'change_pin_validation_state.dart';

class ChangePinValidationCubit extends Cubit<ChangePinValidationState> {
  ChangePinValidationCubit() : super(const ChangePinValidationState());

  bool get isValidated {
    return (state.oldPinError ?? '').isEmpty &&
        (state.newPinError ?? '').isEmpty &&
        (state.newPinConfirmError ?? '').isEmpty;
  }

  void validate(
    AppLocalizations t,
    String? oldPin,
    String? newPin,
    String? newPinConfirm,
  ) {
    bool isOldPinValidated = ValidationUtils.pin(oldPin ?? '');
    if ((oldPin ?? '').isEmpty) {
      emit(state.copyWith(
        oldPinError: '${t.lblOldPin} ${t.lblCantBeEmpty}',
      ));
    } else if (isOldPinValidated == false) {
      emit(state.copyWith(
        oldPinError: t.lblPinValidation,
      ));
    } else {
      emit(state.copyWith(oldPinError: ''));
    }

    bool isNewPinValidated = ValidationUtils.pin(newPin ?? '');
    if ((newPin ?? '').isEmpty) {
      emit(state.copyWith(
        newPinError: '${t.lblNewPin} ${t.lblCantBeEmpty}',
      ));
    } else if (isNewPinValidated == false) {
      emit(state.copyWith(
        newPinError: t.lblPinValidation,
      ));
    } else {
      emit(state.copyWith(newPinError: ''));
    }

    bool isNewConfirmPinValidated = ValidationUtils.pin(newPinConfirm ?? '');
    if ((newPinConfirm ?? '').isEmpty) {
      emit(state.copyWith(
        newPinConfirmError: '${t.lblNewPinConfirmation} ${t.lblCantBeEmpty}',
      ));
    } else if (isNewConfirmPinValidated == false) {
      emit(state.copyWith(
        newPinConfirmError: t.lblPinValidation,
      ));
    } else {
      emit(state.copyWith(newPinConfirmError: ''));
    }

    if ((newPin ?? "").isNotEmpty && (newPinConfirm ?? "").isNotEmpty) {
      if (newPin == newPinConfirm) {
        emit(state.copyWith(newPinError: '', newPinConfirmError: ''));
      } else {
        emit(state.copyWith(
          newPinError: t.lblPinNotMatch,
          newPinConfirmError: t.lblPinNotMatch,
        ));
      }
    }

    if (oldPin == newPin) {
      emit(state.copyWith(
        newPinError: t.lblDontSameOldPin,
      ));
    } else {
      emit(state.copyWith(newPinError: ''));
    }

    if (oldPin == newPinConfirm) {
      emit(state.copyWith(
        newPinConfirmError: t.lblDontSameOldPin,
      ));
    } else {
      emit(state.copyWith(newPinConfirmError: ''));
    }
  }

  void validateOldPin(
    AppLocalizations t,
    String? oldPin,
  ) {
    if ((oldPin ?? '').isEmpty) {
      emit(state.copyWith(
        oldPinError: '${t.lblOldPin} ${t.lblCantBeEmpty}',
      ));
      return;
    }

    bool isOldPinValidated = ValidationUtils.pin(oldPin ?? '');
    if (isOldPinValidated != true) {
      emit(state.copyWith(
        oldPinError: t.lblPinValidation,
      ));
      return;
    }

    emit(state.copyWith(oldPinError: ''));
  }

  void validateNewPin(
    AppLocalizations t,
    String? newPin,
    String? newPinConfirm,
  ) {
    if ((newPin ?? '').isEmpty) {
      emit(state.copyWith(
        newPinError: '${t.lblNewPin} ${t.lblCantBeEmpty}',
      ));
      return;
    }

    bool isNewPinValidated = ValidationUtils.pin(newPin ?? '');
    if (isNewPinValidated != true) {
      emit(state.copyWith(
        newPinError: t.lblPinValidation,
      ));
      return;
    }

    if ((newPinConfirm ?? "").isNotEmpty && newPin != newPinConfirm) {
      emit(state.copyWith(
        newPinError: t.lblPinNotMatch,
        newPinConfirmError: t.lblPinNotMatch,
      ));
      return;
    }

    emit(state.copyWith(newPinError: '', newPinConfirmError: ''));
  }

  void validateNewPinConfirm(
    AppLocalizations t,
    String? newPin,
    String? newPinConfirm,
  ) {
    if ((newPinConfirm ?? '').isEmpty) {
      emit(state.copyWith(
        newPinConfirmError: '${t.lblNewPinConfirmation} ${t.lblCantBeEmpty}',
      ));
      return;
    }

    bool isNewConfirmPinValidated = ValidationUtils.pin(newPinConfirm ?? '');
    if (isNewConfirmPinValidated != true) {
      emit(state.copyWith(
        newPinConfirmError: t.lblPinValidation,
      ));
      return;
    }

    if ((newPinConfirm ?? "").isNotEmpty && newPin != newPinConfirm) {
      emit(state.copyWith(
        newPinError: t.lblPinNotMatch,
        newPinConfirmError: t.lblPinNotMatch,
      ));
      return;
    }

    emit(state.copyWith(newPinError: '', newPinConfirmError: ''));
  }
}
