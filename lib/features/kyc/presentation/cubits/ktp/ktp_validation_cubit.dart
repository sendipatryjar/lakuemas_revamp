import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/validation_utils.dart';

part 'ktp_validation_state.dart';

class KtpValidationCubit extends Cubit<KtpValidationState> {
  KtpValidationCubit() : super(const KtpValidationState());

  bool isValidated() {
    if ((state.isNikError == false) &&
        (state.nikErrorMessages == null) &&
        (state.isNameError == false) &&
        (state.nameErrorMessages == null) &&
        (state.isPobError == false) &&
        (state.pobErrorMessages == null) &&
        (state.isDobError == false) &&
        (state.dobErrorMessages == null) &&
        (state.isKtpPhotoError == false) &&
        (state.ktpPhotoErrorMessages == null)) {
      return true;
    }
    return false;
  }

  void validateKtpNumber({
    required AppLocalizations t,
    String? ktpNumber,
  }) {
    String ktp = ktpNumber ?? '';
    if (ktp.length != 16) {
      emit(state.copyWith(
        isNikError: true,
        nikErrorMessages: t.lblNikMustBe16Digits,
      ));
      return;
    }
    bool isValidKtp = ValidationUtils.ktpNumber(ktp);
    if (isValidKtp == false) {
      emit(state.copyWith(
        isNikError: true,
        nikErrorMessages: 'Mohon masukkan nomor KTP dengan benar',
      ));
      return;
    }
    emit(state.copyWith(
      isNikError: false,
      nullifyNikErrorMessages: true,
    ));
  }

  void validateName({
    required AppLocalizations t,
    String? name,
  }) {
    String nameHelper = name ?? '';
    if (nameHelper.isEmpty) {
      emit(state.copyWith(
        isNameError: true,
        nameErrorMessages: "${t.lblFullName} ${t.lblCantBeEmpty}",
      ));
      return;
    }
    emit(state.copyWith(
      isNameError: false,
      nullifyNameErrorMessages: true,
    ));
  }

  void validatePob({
    required AppLocalizations t,
    String? pob,
  }) {
    String pobHelper = pob ?? '';
    if (pobHelper.isEmpty) {
      emit(state.copyWith(
        isPobError: true,
        pobErrorMessages: "${t.lblPlaceOfBirth} ${t.lblCantBeEmpty}",
      ));
      return;
    }
    emit(state.copyWith(
      isPobError: false,
      nullifyPobErrorMessages: true,
    ));
  }

  void validateDob({
    required AppLocalizations t,
    String? dob,
  }) {
    String dobHelper = dob ?? '';
    if (dobHelper.isEmpty) {
      emit(state.copyWith(
        isDobError: true,
        dobErrorMessages: "${t.lblDateOfBirth} ${t.lblCantBeEmpty}",
      ));
      return;
    }
    emit(state.copyWith(
      isDobError: false,
      nullifyDobErrorMessages: true,
    ));
  }

  void validateKtpPhoto({
    required AppLocalizations t,
    XFile? ktpPhoto,
  }) {
    if (ktpPhoto == null) {
      emit(state.copyWith(
        isKtpPhotoError: true,
        ktpPhotoErrorMessages: 'Foto KTP belum di upload',
      ));
      return;
    }
    emit(state.copyWith(
      isKtpPhotoError: false,
      nullifyKtpPhotoErrorMessages: true,
    ));
  }

  void validate({
    required AppLocalizations t,
    String? ktpNumber,
    String? name,
    String? pob,
    String? dob,
    XFile? ktpPhoto,
  }) {
    validateKtpNumber(
      t: t,
      ktpNumber: ktpNumber,
    );
    validateName(
      t: t,
      name: name,
    );
    validatePob(
      t: t,
      pob: pob,
    );
    validateDob(
      t: t,
      dob: dob,
    );
    validateKtpPhoto(
      t: t,
      ktpPhoto: ktpPhoto,
    );
  }

  void changeTtl(String? value) => emit(state.copyWith(ttl: value));
}
