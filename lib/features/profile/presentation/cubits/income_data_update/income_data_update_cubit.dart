import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/usecases/get_user_data_uc.dart';

part 'income_data_update_state.dart';

class IncomeDataUpdateCubit extends Cubit<IncomeDataUpdateState> {
  final GetUserDataUc getUserDataUc;
  IncomeDataUpdateCubit({required this.getUserDataUc})
      : super(const IncomeDataUpdateState());

  List<String> get occupations => [
        "Pelajar",
        "Ibu Rumah Tangga",
        "Karyawan Swasta",
        "Karyawan BUMN",
        "Pegawai Negeri",
        "TNI / Polri",
        "Pjb. Negara / Daerah",
        "Pensiunan",
        "Pengusaha Pabrik",
        "Pedagang",
        "Pengusaha Jasa",
        "Dokter",
        "Pengacara",
        "Akuntan",
        "Wartawan",
        "Seniman",
        "Notaris",
      ];
  List<String> get incomes => [
        "Hasil Investasi",
        "Gaji",
        "Hasil Usaha",
        "Tabungan",
      ];
  List<String> get purposes => [
        "Investasi",
        "Tabungan",
      ];

  void initSelfData() async {
    final result = await getUserDataUc(isFromLocal: true);
    final r = result.getOrElse(() => null);
    emit(state.copyWith(
      occupation: r?.occupation,
      income: r?.income,
      purpose: r?.purpose,
    ));
  }

  void changeOccupation(String? value) => emit(
        state.copyWith(
          occupation: value,
          occupationErrMessage: '',
        ),
      );
  void changeIncome(String? value) => emit(
        state.copyWith(
          income: value,
          incomeErrMessage: '',
        ),
      );
  void changePurpose(String? value) => emit(
        state.copyWith(
          purpose: value,
          purposeErrMessage: '',
        ),
      );

  void validate({
    required AppLocalizations t,
  }) {
    validateOccupation(t: t);
    validateIncome(t: t);
    validatePurpose(t: t);
  }

  void validateOccupation({
    required AppLocalizations t,
  }) {
    if ((state.occupation ?? '').isEmpty) {
      emit(state.copyWith(
        occupationErrMessage: '${t.lblJob} ${t.lblCantBeEmpty}',
      ));
      return;
    }
  }

  void validateIncome({
    required AppLocalizations t,
  }) {
    if ((state.income ?? '').isEmpty) {
      emit(state.copyWith(
        incomeErrMessage: '${t.lblIncome} ${t.lblCantBeEmpty}',
      ));
      return;
    }
  }

  void validatePurpose({
    required AppLocalizations t,
  }) {
    if ((state.purpose ?? '').isEmpty) {
      emit(state.copyWith(
        purposeErrMessage: '${t.lblAccCreatePurpose} ${t.lblCantBeEmpty}',
      ));
      return;
    }
  }
}
