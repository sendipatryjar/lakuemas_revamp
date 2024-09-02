import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'otp_validation_state.dart';

class OtpValidationCubit extends Cubit<OtpValidationState> {
  OtpValidationCubit() : super(const OtpValidationState());

  void validate({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isError: true,
        errorMessages: t.lblCantBeEmpty,
      ));
      return;
    }
    if ((value?.length ?? 0) < 6) {
      emit(state.copyWith(
        isError: true,
        errorMessages: t.lblIncorrectOtpCode,
      ));
      return;
    }
    emit(state.copyWith(
      isError: false,
      errorMessages: '',
    ));
  }
}
