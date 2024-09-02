import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/entities/city_entity.dart';
import '../../../domain/entities/district_entity.dart';
import '../../../domain/entities/province_entity.dart';

part 'address_data_state.dart';

class AddressDataCubit extends Cubit<AddressDataState> {
  AddressDataCubit() : super(const AddressDataState());

  void changeProvince(ProvinceEntity? value) {
    if (state.isMailSameAsHome) {
      emit(state.copyWith(
        provinceEntity: value,
        mailProvinceEntity: value,
        provinceErrMessage: '',
        mailProvinceErrMessage: '',
        isChangedProvince: state.provinceEntity == null ? false : true,
      ));
      return;
    }
    emit(state.copyWith(
      provinceEntity: value,
      provinceErrMessage: '',
      nullifyCity: true,
      nullifyDistrict: true,
      isChangedProvince: state.provinceEntity == null ? false : true,
    ));
  }

  void initProvince(int provinceId, List<ProvinceEntity> province) {
    final selectedProvince =
        province.where((element) => element.id == provinceId).toList();

    if (selectedProvince.isNotEmpty) {
      changeProvince(selectedProvince.first);
    }
  }

  void changeCity(CityEntity? value) {
    if (state.isMailSameAsHome) {
      emit(state.copyWith(
        cityEntity: value,
        mailCityEntity: value,
        cityErrMessage: '',
        mailCityErrMessage: '',
        nullifyDistrict: true,
        isChangedCity: state.cityEntity == null ? false : true,
      ));
      return;
    }
    emit(state.copyWith(
      cityEntity: value,
      cityErrMessage: '',
      nullifyDistrict: true,
      isChangedCity: state.cityEntity == null ? false : true,
    ));
  }

  void initCity(int cityId, List<CityEntity> city) {
    final selectedCity = city.where((element) => element.id == cityId).toList();

    if (selectedCity.isNotEmpty) {
      changeCity(selectedCity.first);
    }
  }

  void changeDistrict(DistrictEntity? value) {
    if (state.isMailSameAsHome) {
      emit(state.copyWith(
        districtEntity: value,
        mailDistrictEntity: value,
        districtErrMessage: '',
        mailDistrictErrMessage: '',
      ));
      return;
    }
    emit(state.copyWith(
      districtEntity: value,
      districtErrMessage: '',
    ));
  }

  void initDistrict(int districtId, List<DistrictEntity> district) {
    final selectedDistrict =
        district.where((element) => element.id == districtId).toList();

    if (selectedDistrict.isNotEmpty) {
      changeDistrict(selectedDistrict.first);
    }
  }

  void changeIsMailSameAsHome(bool value) {
    if (value) {
      emit(state.copyWith(
        isMailSameAsHome: value,
        mailProvinceEntity: state.provinceEntity,
        mailCityEntity: state.cityEntity,
        mailDistrictEntity: state.districtEntity,
        mailPostalCode: state.postalCode,
        mailAddress: state.address,
        //
        mailProvinceErrMessage: '',
        mailCityErrMessage: '',
        mailDistrictErrMessage: '',
        mailPostalCodeErrMessage: '',
        mailAddressErrMessage: '',
      ));
    } else {
      emit(state.copyWith(
        isMailSameAsHome: value,
        nullifyMailProvince: true,
        nullifyMailCity: true,
        nullifyMailDistrict: true,
        mailPostalCode: '',
        mailAddress: '',
        mailProvinceErrMessage: '',
        mailCityErrMessage: '',
        mailDistrictErrMessage: '',
        mailPostalCodeErrMessage: '',
        mailAddressErrMessage: '',
      ));
    }
  }

  void resetMailAddress() {
    emit(state.copyWith(
      nullifyMailProvince: true,
      nullifyMailCity: true,
      nullifyMailDistrict: true,
    ));
  }

  void changeMailProvince(ProvinceEntity? value) => emit(state.copyWith(
        nullifyMailProvince: value == null,
        mailProvinceEntity: value,
        nullifyMailCity: true,
        nullifyMailDistrict: true,
        isMailSameAsHome: state.isMailSameAsHome,
        mailProvinceErrMessage: '',
        isChangedMailProvince: state.mailProvinceEntity == null ? false : true,
        isChangedMailCity: state.mailCityEntity == null ? false : true,
      ));

  void initMailProvince(int provinceId, List<ProvinceEntity> province) {
    final selectedProvince =
        province.where((element) => element.id == provinceId).toList();

    if (selectedProvince.isNotEmpty) {
      changeMailProvince(selectedProvince.first);
    }
  }

  void changeMailCity(CityEntity? value) => emit(state.copyWith(
        nullifyMailCity: value == null,
        mailCityEntity: value,
        nullifyMailDistrict: true,
        isMailSameAsHome: state.isMailSameAsHome,
        mailCityErrMessage: '',
        isChangedMailCity: state.mailCityEntity == null ? false : true,
      ));

  void initMailCity(int cityId, List<CityEntity> city) {
    final selectedCity = city.where((element) => element.id == cityId).toList();

    if (selectedCity.isNotEmpty) {
      changeMailCity(selectedCity.first);
    }
  }

  void changeMailDistrict(DistrictEntity? value) => emit(state.copyWith(
        nullifyMailDistrict: value == null,
        mailDistrictEntity: value,
        mailDistrictErrMessage: '',
        isMailSameAsHome: state.isMailSameAsHome,
        isChangedMailDistrict: state.mailDistrictEntity == null ? false : true,
      ));

  void initMailDistrict(int districtId, List<DistrictEntity> district) {
    final selectedDistrict =
        district.where((element) => element.id == districtId).toList();

    if (selectedDistrict.isNotEmpty) {
      changeMailDistrict(selectedDistrict.first);
    }
  }

  // Error State

  bool get isValidated {
    return (state.provinceErrMessage ?? '').isEmpty &&
        (state.cityErrMessage ?? '').isEmpty &&
        (state.districtErrMessage ?? '').isEmpty &&
        (state.postalCodeErrMessage ?? '').isEmpty &&
        (state.addressErrMessage ?? '').isEmpty;
  }

  void validateHomeAddress({
    required AppLocalizations t,
    String? value,
  }) {
    validateProvince(t: t);
    validateCity(t: t);
    validateDistrict(t: t);
  }

  bool get isValidatedMail {
    return (state.mailProvinceErrMessage ?? '').isEmpty &&
        (state.mailCityErrMessage ?? '').isEmpty &&
        (state.mailDistrictErrMessage ?? '').isEmpty &&
        (state.mailPostalCodeErrMessage ?? '').isEmpty &&
        (state.mailAddressErrMessage ?? '').isEmpty;
  }

  void validatedMailAddress({
    required AppLocalizations t,
    String? value,
  }) {
    validateMailProvince(t: t);
    validateMailCity(t: t);
    validateMailDistrict(t: t);
  }

  void validateProvince({
    required AppLocalizations t,
  }) {
    if (state.provinceEntity == null) {
      emit(state.copyWith(
        provinceErrMessage: '${t.lblProvince} ${t.lblCantBeEmpty}',
      ));
    }
  }

  void validateCity({
    required AppLocalizations t,
  }) {
    if (state.cityEntity == null) {
      emit(state.copyWith(
        cityErrMessage: '${t.lblCity} ${t.lblCantBeEmpty}',
      ));
    }
  }

  void validateDistrict({
    required AppLocalizations t,
  }) {
    if (state.districtEntity == null) {
      emit(state.copyWith(
        districtErrMessage: '${t.lblDistrict} ${t.lblCantBeEmpty}',
      ));
    }
  }

  void validatePostalCode({
    required AppLocalizations t,
    String? value,
  }) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isPostalCodeError: true,
        postalCodeErrMessage: '${t.lblPostalCode} ${t.lblCantBeEmpty}',
      ));
      return;
    }

    if ((value ?? '').length < 5) {
      emit(state.copyWith(
        isPostalCodeError: true,
        postalCodeErrMessage: '${t.lblPostalCode} harus 5 digit',
      ));
      return;
    }

    emit(state.copyWith(
      isPostalCodeError: false,
      postalCodeErrMessage: '',
    ));
  }

  void validateAddress({
    required AppLocalizations t,
    String? value,
  }) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isAddressError: true,
        addressErrMessage: '${t.lblAddress} ${t.lblCantBeEmpty}',
      ));
      return;
    }
    emit(state.copyWith(
      isAddressError: false,
      addressErrMessage: '',
    ));
  }

  //

  void validateMailProvince({
    required AppLocalizations t,
  }) {
    if (state.mailProvinceEntity == null) {
      emit(state.copyWith(
        mailProvinceErrMessage: '${t.lblProvince} ${t.lblCantBeEmpty}',
      ));
    }
  }

  void validateMailCity({
    required AppLocalizations t,
  }) {
    if (state.mailCityEntity == null) {
      emit(state.copyWith(
        mailCityErrMessage: '${t.lblCity} ${t.lblCantBeEmpty}',
      ));
    }
  }

  void validateMailDistrict({
    required AppLocalizations t,
  }) {
    if (state.mailDistrictEntity == null) {
      emit(state.copyWith(
        mailDistrictErrMessage: '${t.lblDistrict} ${t.lblCantBeEmpty}',
      ));
    }
  }

  void validateMailPostalCode({
    required AppLocalizations t,
    String? value,
  }) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isMailPostalCodeError: true,
        mailPostalCodeErrMessage: '${t.lblPostalCode} ${t.lblCantBeEmpty}',
      ));
      return;
    }
    if ((value ?? '').length < 5) {
      emit(state.copyWith(
        isMailPostalCodeError: true,
        mailPostalCodeErrMessage: '${t.lblPostalCode} harus 5 digit',
      ));
      return;
    }
    emit(state.copyWith(
      isMailPostalCodeError: false,
      mailPostalCodeErrMessage: '',
    ));
  }

  void validateAddressMail({
    required AppLocalizations t,
    String? value,
  }) {
    if ((value ?? '').isEmpty) {
      emit(state.copyWith(
        isMailAddressError: true,
        mailAddressErrMessage: '${t.lblAddress} ${t.lblCantBeEmpty}',
      ));
      return;
    }
    emit(state.copyWith(
      isMailAddressError: false,
      mailAddressErrMessage: '',
    ));
  }
}
