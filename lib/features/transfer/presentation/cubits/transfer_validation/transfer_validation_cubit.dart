import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../features/transfer/presentation/cubits/transfer/transfer_cubit.dart';

part 'transfer_validation_state.dart';

class TransferValidationCubit extends Cubit<TransferValidationState> {
  TransferValidationCubit() : super(const TransferValidationState());

  bool get isValid {
    // if (state.enTransfer == EnTransfer.favAccount) {
    //   return state.isTotalGoldError == false;
    // }
    return state.isTotalGoldError == false && state.isNoRekeningError == false;
  }

  void resetValidateGold() => emit(state.copyWith(nullifyTotalGoldError: true));
  void resetValidateRekening() =>
      emit(state.copyWith(nullifyRekeningError: true));

  void valueTab(EnTransfer enTransfer) {
    emit(state.copyWith(
      enTransfer: enTransfer,
      nullifyTotalGoldError: true,
      nullifyRekeningError: true,
    ));
  }

  void validate({
    required AppLocalizations t,
    required String totalGold,
    required double? goldBalance,
    required String? noRekening,
    required String? noRekeningFromFav,
  }) {
    _validateTotalGold(t: t, value: totalGold, goldBalance: goldBalance);
    String? noRek = (state.enTransfer == EnTransfer.newAccount)
        ? noRekening
        : noRekeningFromFav;
    _validateNoRekening(t: t, value: noRek);
  }

  void _validateTotalGold(
      {required AppLocalizations t, String? value, double? goldBalance}) {
    double goldAmount = double.parse((value ?? '0').isNotEmpty ? value! : '0');
    if (goldAmount <= 0) {
      emit(state.copyWith(
        isTotalGoldError: true,
        totalGoldErrorMessages: 'Jumlah Emas tidak boleh kosong',
      ));
      return;
    }
    if (goldAmount < 0.0003) {
      emit(state.copyWith(
        isTotalGoldError: true,
        totalGoldErrorMessages: 'Minimum Transfer adalah 0.0003 gram',
      ));
      return;
    }
    if (goldBalance == null) {
      emit(state.copyWith(
        isTotalGoldError: true,
        totalGoldErrorMessages: t.lblSomethingWrong,
      ));
      return;
    }
    if (goldAmount > goldBalance) {
      emit(state.copyWith(
        isTotalGoldError: true,
        totalGoldErrorMessages: 'Saldo Emas tidak cukup',
      ));
      return;
    }

    emit(state.copyWith(
      isTotalGoldError: false,
      totalGoldErrorMessages: '',
    ));
  }

  void _validateNoRekening({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isNoRekeningError: true,
        noRekeningErrorMessages: 'Nomor Rekening tidak boleh kosong',
      ));
      return;
    }

    emit(state.copyWith(
      isNoRekeningError: false,
      noRekeningErrorMessages: '',
    ));
    return;
  }
}
