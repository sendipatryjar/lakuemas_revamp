import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../cores/utils/validation_utils.dart';

part 'npwp_verification_validation_state.dart';

class NpwpVerificationValidationCubit
    extends Cubit<NpwpVerificationValidationState> {
  NpwpVerificationValidationCubit()
      : super(const NpwpVerificationValidationState());

  bool get isValid {
    return (state.isNpwpError == false) && (state.isNpwpPhotoError == false);
  }

  bool get isValidNpwpNo => state.isNpwpError == false;
  bool get isValidNpwpPhoto => state.isNpwpPhotoError == false;

  void validate({
    required AppLocalizations t,
    required String? npwpNo,
    required XFile? file,
  }) {
    validateNpwpNo(t: t, value: npwpNo);
    _validateNpwpPhoto(t: t, value: file);
  }

  void validateNpwpNo({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isNpwpError: true,
        npwpErrorMessages: 'Nomor NPWP harus 15 digit angka',
      ));
      return;
    }
    if (ValidationUtils.npwpNumber(value ?? '', ignoreLength: true) == false) {
      emit(
        state.copyWith(
          isNpwpError: true,
          npwpErrorMessages: 'Mohon masukkan nomor NPWP dengan benar',
        ),
      );
      return;
    }
    if (value?.length != 15) {
      emit(state.copyWith(
        isNpwpError: true,
        npwpErrorMessages: 'Nomor NPWP harus 15 digit angka',
      ));
      return;
    }
    emit(state.copyWith(
      isNpwpError: false,
      npwpErrorMessages: '',
    ));
  }

  void _validateNpwpPhoto({required AppLocalizations t, XFile? value}) {
    if (value == null) {
      emit(
        state.copyWith(
          isNpwpPhotoError: true,
          npwpPhotoErrorMessages: 'Foto NPWP belum diupload',
        ),
      );
      return;
    }
    emit(state.copyWith(
      isNpwpPhotoError: false,
      npwpPhotoErrorMessages: '',
    ));
  }
}
