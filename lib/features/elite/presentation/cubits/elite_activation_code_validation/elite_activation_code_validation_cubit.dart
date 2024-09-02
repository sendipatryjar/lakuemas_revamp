import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'elite_activation_code_validation_state.dart';

class EliteActivationCodeValidationCubit
    extends Cubit<EliteActivationCodeValidationState> {
  EliteActivationCodeValidationCubit()
      : super(const EliteActivationCodeValidationState());

  bool get isValid => state.isActivationCodeError == false;

  void validate({
    required AppLocalizations t,
    required String activationCode,
  }) {
    _validateActivationCode(t: t, value: activationCode);
  }

  void _validateActivationCode({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isActivationCodeError: true,
        activationCodeErrorMessage: 'Kode Aktivasi tidak boleh kosong',
      ));
      return;
    }
    emit(state.copyWith(
      isActivationCodeError: false,
      activationCodeErrorMessage: '',
    ));
  }
}
