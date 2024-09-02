import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'elite_unsub_validation_state.dart';

class EliteUnsubValidationCubit extends Cubit<EliteUnsubValidationState> {
  EliteUnsubValidationCubit() : super(const EliteUnsubValidationState());

  bool get isValid => state.isReasonUnsubError == false;

  void updateReasonCb(String? value) {
    emit(state.copyWith(
      nullifyReasonUnsubMessageCb: value == null,
      reasonUnsubMessagesCb: value,
    ));
  }

  void validate({
    required AppLocalizations t,
    required String reasonUnsub,
  }) {
    _validatereasonUnsub(t: t, value: reasonUnsub);
  }

  void _validatereasonUnsub({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isReasonUnsubError: true,
        reasonUnsubMessages: 'Alasan berhenti berlangganan tidak boleh kosong',
      ));
      return;
    }

    emit(state.copyWith(
      isReasonUnsubError: false,
      reasonUnsubMessages: value,
    ));
  }
}
