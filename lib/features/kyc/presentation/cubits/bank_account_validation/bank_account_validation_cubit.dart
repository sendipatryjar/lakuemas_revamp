import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entities/get_banks_entity.dart';

part 'bank_account_validation_state.dart';

class BankAccountValidationCubit extends Cubit<BankAccountValidationState> {
  BankAccountValidationCubit() : super(const BankAccountValidationState());

  bool get isValidd =>
      state.isAccountNumberError == false &&
      (state.accountNumberErrorMessages ?? '').isEmpty &&
      state.isBankError == false &&
      (state.bankErrorMessages ?? '').isEmpty;

  void validate({
    required AppLocalizations t,
    required String accountNumber,
    required GetBanksEntity? bankAccountEntity,
  }) {
    validateAccountNumber(t: t, value: accountNumber);
    validateAccountBank(t: t, bankAccountEntity: bankAccountEntity);
  }

  void validateAccountNumber({required AppLocalizations t, String? value}) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isAccountNumberError: true,
        accountNumberErrorMessages: t.lblAccountNumberIsEmpty,
      ));
      return;
    }
    emit(state.copyWith(
      isAccountNumberError: false,
      accountNumberErrorMessages: '',
    ));
  }

  void validateAccountBank({
    required AppLocalizations t,
    GetBanksEntity? bankAccountEntity,
  }) {
    if (bankAccountEntity == null) {
      emit(state.copyWith(
        isBankError: true,
        bankErrorMessages: 'bank tidak boleh kosong',
      ));
      return;
    }
    emit(state.copyWith(
      isBankError: false,
      bankErrorMessages: '',
    ));
  }
}
