import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/get_banks_entity.dart';
part 'bank_account_state.dart';

class BankAccountCubit extends Cubit<BankAccountStateCubit> {
  BankAccountCubit() : super(const BankAccountStateCubit());

  void changeBanks(GetBanksEntity? value) {
    emit(state.copyWith(bankAccountEntity: value));
  }

  void initBank(int initialBankId, List<GetBanksEntity> bank) {
    final selectedBank =
        bank.where((element) => element.id == initialBankId).toList();

    if (selectedBank.isNotEmpty) {
      changeBanks(selectedBank.first);
    }
  }
}
