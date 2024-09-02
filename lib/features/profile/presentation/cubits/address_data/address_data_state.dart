part of 'address_data_cubit.dart';

class AddressDataState extends Equatable {
  final ProvinceEntity? provinceEntity;
  final CityEntity? cityEntity;
  final DistrictEntity? districtEntity;
  final String? postalCode;
  final String? address;
  final bool isMailSameAsHome;
  final ProvinceEntity? mailProvinceEntity;
  final CityEntity? mailCityEntity;
  final DistrictEntity? mailDistrictEntity;
  final String? mailPostalCode;
  final String? mailAddress;
  //
  final String? provinceErrMessage;
  final String? cityErrMessage;
  final String? districtErrMessage;
  final bool? isPostalCodeError;
  final String? postalCodeErrMessage;
  final bool? isAddressError;
  final String? addressErrMessage;
  final String? mailProvinceErrMessage;
  final String? mailCityErrMessage;
  final String? mailDistrictErrMessage;
  final bool? isMailPostalCodeError;
  final String? mailPostalCodeErrMessage;
  final bool? isMailAddressError;
  final String? mailAddressErrMessage;
  final bool? isChangedProvince;
  final bool? isChangedCity;
  final bool? isChangedMailProvince;
  final bool? isChangedMailCity;
  final bool? isChangedMailDistrict;

  const AddressDataState({
    this.provinceEntity,
    this.cityEntity,
    this.districtEntity,
    this.postalCode,
    this.address,
    this.isMailSameAsHome = false,
    this.mailProvinceEntity,
    this.mailCityEntity,
    this.mailDistrictEntity,
    this.mailPostalCode,
    this.mailAddress,
    // home error
    this.provinceErrMessage,
    this.cityErrMessage,
    this.districtErrMessage,
    this.isPostalCodeError = false,
    this.postalCodeErrMessage,
    this.isAddressError = false,
    this.addressErrMessage,
    // mail error
    this.mailProvinceErrMessage,
    this.mailCityErrMessage,
    this.mailDistrictErrMessage,
    this.isMailPostalCodeError = false,
    this.mailPostalCodeErrMessage,
    this.isMailAddressError = false,
    this.mailAddressErrMessage,
    this.isChangedProvince = false,
    this.isChangedCity = false,
    this.isChangedMailProvince = false,
    this.isChangedMailCity = false,
    this.isChangedMailDistrict = false,
  });

  AddressDataState copyWith({
    ProvinceEntity? provinceEntity,
    bool? nullifyProvince,
    CityEntity? cityEntity,
    bool? nullifyCity,
    DistrictEntity? districtEntity,
    bool? nullifyDistrict,
    String? postalCode,
    String? address,
    bool? isMailSameAsHome,
    ProvinceEntity? mailProvinceEntity,
    bool? nullifyMailProvince,
    CityEntity? mailCityEntity,
    bool? nullifyMailCity,
    DistrictEntity? mailDistrictEntity,
    bool? nullifyMailDistrict,
    String? mailPostalCode,
    String? mailAddress,
    // home error
    String? provinceErrMessage,
    String? cityErrMessage,
    String? districtErrMessage,
    bool? isPostalCodeError,
    String? postalCodeErrMessage,
    bool? isAddressError,
    String? addressErrMessage,
    // mail
    String? mailProvinceErrMessage,
    String? mailCityErrMessage,
    String? mailDistrictErrMessage,
    bool? isMailPostalCodeError,
    String? mailPostalCodeErrMessage,
    bool? isMailAddressError,
    String? mailAddressErrMessage,
    bool? isChangedProvince,
    bool? isChangedCity,
    bool? isChangedMailProvince,
    bool? isChangedMailCity,
    bool? isChangedMailDistrict,
  }) =>
      AddressDataState(
        provinceEntity: nullifyProvince == true
            ? null
            : provinceEntity ?? this.provinceEntity,
        cityEntity: nullifyCity == true ? null : cityEntity ?? this.cityEntity,
        districtEntity: nullifyDistrict == true
            ? null
            : districtEntity ?? this.districtEntity,
        postalCode: postalCode ?? this.postalCode,
        address: address ?? this.address,
        isMailSameAsHome: isMailSameAsHome ?? this.isMailSameAsHome,
        mailProvinceEntity: nullifyMailProvince == true
            ? null
            : mailProvinceEntity ?? this.mailProvinceEntity,
        mailCityEntity: nullifyMailCity == true
            ? null
            : mailCityEntity ?? this.mailCityEntity,
        mailDistrictEntity: nullifyMailDistrict == true
            ? null
            : mailDistrictEntity ?? this.mailDistrictEntity,
        mailPostalCode: mailPostalCode ?? this.mailPostalCode,
        mailAddress: mailAddress ?? this.mailAddress,
        //
        provinceErrMessage: provinceErrMessage ?? this.provinceErrMessage,
        cityErrMessage: cityErrMessage ?? this.cityErrMessage,
        districtErrMessage: districtErrMessage ?? this.districtErrMessage,
        isPostalCodeError: isPostalCodeError ?? this.isPostalCodeError,
        postalCodeErrMessage: postalCodeErrMessage ?? this.postalCodeErrMessage,
        isAddressError: isAddressError ?? this.isAddressError,
        addressErrMessage: addressErrMessage ?? this.addressErrMessage,
        //
        mailProvinceErrMessage:
            mailProvinceErrMessage ?? this.mailProvinceErrMessage,
        mailCityErrMessage: mailCityErrMessage ?? this.mailCityErrMessage,
        mailDistrictErrMessage:
            mailDistrictErrMessage ?? this.mailDistrictErrMessage,
        isMailPostalCodeError:
            isMailPostalCodeError ?? this.isMailPostalCodeError,
        mailPostalCodeErrMessage:
            mailPostalCodeErrMessage ?? this.mailPostalCodeErrMessage,
        isMailAddressError: isMailAddressError ?? this.isMailAddressError,
        mailAddressErrMessage:
            mailAddressErrMessage ?? this.mailAddressErrMessage,
        //
        isChangedProvince: isChangedProvince ?? this.isChangedProvince,
        isChangedCity: isChangedCity ?? this.isChangedCity,
        isChangedMailProvince:
            isChangedMailProvince ?? this.isChangedMailProvince,
        isChangedMailCity: isChangedMailCity ?? this.isChangedMailCity,
        isChangedMailDistrict:
            isChangedMailDistrict ?? this.isChangedMailDistrict,
      );

  @override
  List<Object> get props => [
        [
          provinceEntity,
          cityEntity,
          districtEntity,
          postalCode,
          address,
          isMailSameAsHome,
          mailProvinceEntity,
          mailCityEntity,
          mailDistrictEntity,
          mailPostalCode,
          mailAddress,
          //
          provinceErrMessage,
          cityErrMessage,
          districtErrMessage,
          isPostalCodeError,
          postalCodeErrMessage,
          isAddressError,
          addressErrMessage,
          //
          mailProvinceErrMessage,
          mailCityErrMessage,
          mailDistrictErrMessage,
          isMailPostalCodeError,
          mailPostalCodeErrMessage,
          isMailAddressError,
          mailAddressErrMessage,
          //
          isChangedProvince,
          isChangedCity,
          isChangedMailProvince,
          isChangedMailCity,
          isChangedMailDistrict
        ]
      ];
}
