import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/utils/app_utils.dart';
import '../../../../_core/user/domain/entities/user_data_entity.dart';
import '../../../domain/usecases/get_user_data_uc.dart';

part 'self_data_update_state.dart';

class SelfDataUpdateCubit extends Cubit<SelfDataUpdateState> {
  final GetUserDataUc getUserDataUc;
  SelfDataUpdateCubit({required this.getUserDataUc})
      : super(const SelfDataUpdateState());

  List<String> get genders => ["Pria", "Wanita"];

  List<String> get maritalStatuses => ["Menikah", "Lajang", "Cerai"];

  List<String> get religions =>
      ["Islam", "Kristen", "Budha", "Katholik", "Hindu"];

  void initSelfData() async {
    final result = await getUserDataUc(isFromLocal: true);
    final r = result.getOrElse(() => null);
    emit(state.copyWith(
      userDataEntity: r,
      fullName: r?.name,
      gender: r?.gender,
      cob: r?.countryOfBirth,
      pob: r?.placeOfBirth,
      dob: r?.dateOfBirth,
      maritalStatus: r?.maritalStatus,
      religion: r?.religion,
    ));
  }

  void changeFullName(String value) => emit(state.copyWith(fullName: value));

  void changeGender(String value) => emit(state.copyWith(gender: value));

  void changeCob(String value) => emit(state.copyWith(cob: value));

  void changePob(String value) => emit(state.copyWith(pob: value));

  void changeDob(String value) => emit(state.copyWith(dob: value));

  void changeMaritalStatus(String value) => emit(state.copyWith(
        maritalStatus: value,
        maritalErrorMessage: '',
      ));

  void changeReligion(String value) => emit(state.copyWith(
        religion: value,
        religionErrorMessage: '',
      ));

  void validate({
    required AppLocalizations t,
    Function()? onValidated,
  }) {
    // bool isFullNameUpdated = state.userDataEntity?.name != state.fullName;
    bool isGenderUpdated = state.userDataEntity?.gender != state.gender;
    bool isPobUpdated = state.userDataEntity?.placeOfBirth != state.pob;
    bool isDobUpdated = state.userDataEntity?.dateOfBirth != state.dob;
    bool isMaritalStatusUpdated =
        state.userDataEntity?.maritalStatus != state.maritalStatus;
    bool isReligionUpdated = state.userDataEntity?.religion != state.religion;

    // if ((state.fullName ?? '').isEmpty) {
    //   emit(
    //     state.copyWith(
    //       isNameError: true,
    //       isNameErrorMessage: 'Nama tidak boleh kosong',
    //     ),
    //   );
    //   return;
    // }

    // if ((state.gender ?? '').isEmpty) {
    //   emit(
    //     state.copyWith(
    //       genderErrorMessage: 'Jenis Kelamin tidak boleh kosong',
    //     ),
    //   );
    //   return;
    // }

    // if ((state.pob ?? '').isEmpty) {
    //   emit(
    //     state.copyWith(
    //       isPobError: true,
    //       isPobErrorMessage: 'Tempat Lahir tidak boleh kosong',
    //     ),
    //   );
    //   return;
    // }

    // if ((state.dob ?? '').isEmpty) {
    //   emit(
    //     state.copyWith(
    //       dobErrorMessage: 'Tanggal Lahir tidak boleh kosong',
    //     ),
    //   );
    //   return;
    // }

    // if ((state.maritalStatus ?? '').isEmpty) {
    //   emit(
    //     state.copyWith(
    //       maritalErrorMessage: 'Status Pernikahan tidak boleh kosong',
    //     ),
    //   );
    //   return;
    // }

    // if ((state.religion ?? '').isEmpty) {
    //   emit(
    //     state.copyWith(
    //       religionErrorMessage: 'Agama tidak boleh kosong',
    //     ),
    //   );
    //   return;
    // }

    if (
        // isFullNameUpdated ||
        isGenderUpdated ||
            isPobUpdated ||
            isDobUpdated ||
            isMaritalStatusUpdated ||
            isReligionUpdated) {
      appPrint('update');
      if (onValidated != null) onValidated();
      return;
    }
    appPrint('data didnt changed and nothing happened');
  }
}
