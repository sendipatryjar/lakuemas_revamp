import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'elite_referal_validation_state.dart';

class EliteReferalValidationCubit
    extends Cubit<EliteReferalValidationCubitState> {
  EliteReferalValidationCubit()
      : super(const EliteReferalValidationCubitState());

  bool get isValid => state.isReferalError == false;

  void validate({
    required AppLocalizations t,
    required String referalCode,
  }) {
    _validateReferalCode(t: t, value: referalCode);
  }

  void _validateReferalCode({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isReferalError: true,
        referalErrorMessages: 'Kode Referal tidak boleh kosong',
      ));
      return;
    }
    emit(state.copyWith(
      isReferalError: false,
      referalErrorMessages: '',
    ));
  }
}
