import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entities/bank_me_entity.dart';

part 'cash_withdrawal_state.dart';

class CashWithdrawalCubit extends Cubit<CashWithdrawalState> {
  CashWithdrawalCubit() : super(const CashWithdrawalState());

  bool get isValid => state.isNominalError == false;

  double get minNominalCash => (state.minDenom ?? 100000) + (state.fee ?? 0);

  void fillMinimumDenom(String? minDenom) {
    double? minDenomDbl = double.tryParse(minDenom ?? '');
    emit(state.copyWith(
      minDenom: minDenomDbl,
    ));
  }

  void fillBankMe(BankMeEntity? bankMeEntity) {
    double? feeDbl = double.tryParse(bankMeEntity?.serviceFee ?? '');
    emit(state.copyWith(
      fee: feeDbl,
      bankMeEntity: bankMeEntity,
    ));
  }

  void changeIsSelected(bool isSelected) =>
      emit(state.copyWith(isSelected: isSelected));

  void validate({
    required AppLocalizations t,
    required String nominalCash,
    required double currentBalance,
  }) {
    _validateNominalCash(
      t: t,
      value: nominalCash,
      currentBalance: currentBalance,
    );
  }

  void _validateNominalCash({
    required AppLocalizations t,
    String? value,
    required double currentBalance,
  }) {
    value = value?.replaceAll('.', '');
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isNominalError: true,
        isNominalErrorMessages: 'Nominal tidak boleh kosong',
      ));
      return;
    }

    if (double.tryParse((value ?? ''))! > currentBalance) {
      emit(state.copyWith(
        isNominalError: true,
        isNominalErrorMessages: t.lblYourAccountBalanceIsNotEnough,
      ));
      return;
    }

    if (double.tryParse((value ?? ''))! < minNominalCash) {
      emit(state.copyWith(
        isNominalError: true,
        isNominalErrorMessages: '',
      ));
      return;
    }

    emit(state.copyWith(
      isNominalError: false,
      isNominalErrorMessages: '',
    ));
    return;
  }
}
