// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/constants/img_assets.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/checkbox/main_checkbox.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_dropdown_search.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../domain/entities/city_entity.dart';
import '../domain/entities/district_entity.dart';
import '../domain/entities/province_entity.dart';
import '../domain/entities/update_address_entity.dart';
import 'blocs/city/city_bloc.dart';
import 'blocs/city/home/home_city_bloc.dart';
import 'blocs/city/mail/mail_city_bloc.dart';
import 'blocs/district/district_bloc.dart';
import 'blocs/district/home/home_district_bloc.dart';
import 'blocs/district/mail/mail_district_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/profile_address_update/profile_address_update_bloc.dart';
import 'blocs/province/home/home_province_bloc.dart';
import 'blocs/province/mail/mail_province_bloc.dart';
import 'blocs/province/province_bloc.dart';
import 'cubits/address_data/address_data_cubit.dart';

class AddressUpdateScreen extends StatelessWidget {
  int? initialProvinceId;
  int? initialCityId;
  int? initialDistrictId;
  String? initPostalCode;
  String? initHomeAddress;
  //
  int? initMailProvinceId;
  int? initMailCityId;
  int? initMailDistrictId;
  String? initMailPostalCode;
  String? initMailAddress;

  AddressUpdateScreen({
    super.key,
    this.initialProvinceId,
    this.initialCityId,
    this.initialDistrictId,
    this.initPostalCode,
    this.initHomeAddress,
    //
    this.initMailProvinceId,
    this.initMailCityId,
    this.initMailDistrictId,
    this.initMailPostalCode,
    this.initMailAddress,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<HomeProvinceBloc>()..add(const ProvinceGetEvent()),
        ),
        BlocProvider(
          create: (context) =>
              sl<MailProvinceBloc>()..add(const ProvinceGetEvent()),
        ),
        BlocProvider(
          create: (context) => sl<HomeCityBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<MailCityBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<HomeDistrictBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<MailDistrictBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<AddressDataCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileAddressUpdateBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileAddressUpdateBloc, ProfileAddressUpdateState>(
            listener: (context, state) {
              if (state is ProfileAddressUpdateLoadingState) {
                EasyLoading.show();
              }
              if (state is ProfileAddressUpdateSuccessState) {
                EasyLoading.dismiss();
                context.read<HelperDataCubit>().updateUserData(null);
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  context.goNamed(AppRoutes.profile);
                });
                DialogUtils.success(
                  context: context,
                  barrierDismissible: false,
                  firstDesc: t.lblDataSavedSuccess,
                );
              }
              if (state is ProfileAddressUpdateFailureState) {
                EasyLoading.showError(
                  errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                  dismissOnTap: true,
                );
              }
            },
          ),
          BlocListener<HomeProvinceBloc, ProvinceState>(
            listener: (context, state) {
              if (state is ProvinceSuccessState) {
                final isChanged =
                    context.read<AddressDataCubit>().state.isChangedProvince;
                if (isChanged == false) {
                  if (initialProvinceId != null) {
                    context
                        .read<AddressDataCubit>()
                        .initProvince(initialProvinceId!, state.data);

                    context
                        .read<HomeCityBloc>()
                        .add(CityGetEvent(provinceId: initialProvinceId));
                  }
                  return;
                }
              }
            },
          ),
          BlocListener<HomeCityBloc, CityState>(
            listener: (context, state) {
              if (state is CitySuccessState) {
                final isChanged =
                    context.read<AddressDataCubit>().state.isChangedProvince;
                if (isChanged == false) {
                  if (initialCityId != null) {
                    context
                        .read<AddressDataCubit>()
                        .initCity(initialCityId!, state.data);

                    context
                        .read<HomeDistrictBloc>()
                        .add(DistrictGetEvent(cityId: initialCityId));
                  }
                  return;
                }
              }
            },
          ),
          BlocListener<HomeDistrictBloc, DistrictState>(
            listener: (context, state) {
              if (state is DistrictSuccessState) {
                final isChanged =
                    context.read<AddressDataCubit>().state.isChangedCity;
                if (isChanged == false) {
                  if (initialDistrictId != null) {
                    context
                        .read<AddressDataCubit>()
                        .initDistrict(initialDistrictId!, state.data);
                  }
                  return;
                }
              }
            },
          ),

          // Mail Listener
          BlocListener<MailProvinceBloc, ProvinceState>(
            listenWhen: (previous, current) => true,
            listener: (context, state) {
              if (state is ProvinceSuccessState) {
                // final isChanged = context
                //     .read<AddressDataCubit>()
                //     .state
                //     .isChangedMailProvince;
                final isChanged =
                    context.read<AddressDataCubit>().state.isMailSameAsHome;
                if (isChanged == false) {
                  if (initMailProvinceId != null) {
                    context
                        .read<AddressDataCubit>()
                        .initMailProvince(initMailProvinceId!, state.data);

                    context
                        .read<MailCityBloc>()
                        .add(CityGetEvent(provinceId: initMailProvinceId));
                  }
                }
              }
            },
          ),
          BlocListener<MailCityBloc, CityState>(
            listener: (context, state) {
              if (state is CitySuccessState) {
                // final isChanged = context
                //     .read<AddressDataCubit>()
                //     .state
                //     .isChangedMailProvince;
                final isChanged =
                    context.read<AddressDataCubit>().state.isMailSameAsHome;
                if (isChanged == false) {
                  if (initMailCityId != null) {
                    context
                        .read<AddressDataCubit>()
                        .initMailCity(initMailCityId!, state.data);

                    context
                        .read<MailDistrictBloc>()
                        .add(DistrictGetEvent(cityId: initMailCityId));
                  }
                }
              }
            },
          ),
          BlocListener<MailDistrictBloc, DistrictState>(
            listener: (context, state) {
              if (state is DistrictSuccessState) {
                final isChanged =
                    context.read<AddressDataCubit>().state.isMailSameAsHome;
                if (isChanged == false) {
                  if (initMailDistrictId != null) {
                    context
                        .read<AddressDataCubit>()
                        .initMailDistrict(initMailDistrictId!, state.data);
                  }
                  return;
                }
              }
            },
          ),
        ],
        child: _Content(
          initialProvinceId: initialProvinceId,
          initialCityId: initialCityId,
          initialDistrictId: initialDistrictId,
          initPostalCode: initPostalCode,
          initHomeAddress: initHomeAddress,
          //
          initMailProvinceId: initMailProvinceId,
          initMailCityId: initMailCityId,
          initMailDistrictId: initMailDistrictId,
          initMailPostalCode: initMailPostalCode,
          initMailAddress: initMailAddress,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  int? initialProvinceId;
  int? initialCityId;
  int? initialDistrictId;
  String? initPostalCode;
  String? initHomeAddress;
  //
  int? initMailProvinceId;
  int? initMailCityId;
  int? initMailDistrictId;
  String? initMailPostalCode;
  String? initMailAddress;
  _Content({
    Key? key,
    this.initialProvinceId,
    this.initialCityId,
    this.initialDistrictId,
    this.initPostalCode,
    this.initHomeAddress,
    //
    this.initMailProvinceId,
    this.initMailCityId,
    this.initMailDistrictId,
    this.initMailPostalCode,
    this.initMailAddress,
  }) : super(key: key);

  late final _postalCodeTec = TextEditingController(text: initPostalCode);
  late final _addressTec = TextEditingController(text: initHomeAddress);
  final _addressFocus = FocusNode();
  late final _mailPostalCodeTec =
      TextEditingController(text: initMailPostalCode);
  late final _mailAddressTec = TextEditingController(text: initMailAddress);
  final _mailAddressFocus = FocusNode();

  Widget _homeField(
    BuildContext context,
    AppLocalizations t,
    int? initialProvinceId,
    int? initialCityId,
    int? initialDistrictId,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<HomeProvinceBloc, ProvinceState>(
            builder: (context, state) {
              List<ProvinceEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (state is ProvinceLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (state is ProvinceSuccessState) {
                dsState = MainDropdownSearchState.active;
                items = state.data;
              }

              return BlocBuilder<AddressDataCubit, AddressDataState>(
                buildWhen: (previous, current) =>
                    previous != current ||
                    previous.provinceErrMessage != current.provinceErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<ProvinceEntity>(
                    title: t.lblProvince,
                    hintText: '${t.lblSelect} ${t.lblYourHomeProvince}',
                    items: items,
                    itemAsString: (value) => value.name ?? '',
                    selectedItem: state.provinceEntity,
                    onChanged: (value) {
                      context.read<AddressDataCubit>().changeProvince(value);
                      context
                          .read<HomeCityBloc>()
                          .add(CityGetEvent(provinceId: value?.id));
                      context
                          .read<HomeDistrictBloc>()
                          .add(DistrictBackToInitEvent());
                    },
                    errorMessage: state.provinceErrMessage ?? '',
                    state: dsState,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          BlocBuilder<HomeCityBloc, CityState>(
            builder: (context, state) {
              List<CityEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (state is CityInitialState) {
                dsState = MainDropdownSearchState.disabled;
              }
              if (state is CityLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (state is CitySuccessState) {
                dsState = MainDropdownSearchState.active;
                items = state.data;
              }

              return BlocBuilder<AddressDataCubit, AddressDataState>(
                buildWhen: (previous, current) =>
                    previous != current ||
                    previous.cityErrMessage != current.cityErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<CityEntity>(
                    title: t.lblCity,
                    hintText: '${t.lblSelect} ${t.lblCity}',
                    items: items,
                    itemAsString: (value) => value.city ?? '',
                    selectedItem: state.isChangedProvince == true
                        ? null
                        : state.cityEntity,
                    onChanged: (value) {
                      context.read<AddressDataCubit>().changeCity(value);
                      context
                          .read<HomeDistrictBloc>()
                          .add(DistrictGetEvent(cityId: value?.id));
                    },
                    state: dsState,
                    errorMessage: state.cityErrMessage ?? '',
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          BlocBuilder<HomeDistrictBloc, DistrictState>(
            builder: (context, state) {
              List<DistrictEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (state is DistrictInitialState) {
                dsState = MainDropdownSearchState.disabled;
              }
              if (state is DistrictLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (state is DistrictSuccessState) {
                dsState = MainDropdownSearchState.active;
                items = state.data;
              }

              return BlocBuilder<AddressDataCubit, AddressDataState>(
                buildWhen: (previous, current) =>
                    previous != current ||
                    previous.districtErrMessage != current.districtErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<DistrictEntity>(
                    title: t.lblDistrict,
                    hintText: '${t.lblSelect} ${t.lblDistrict}',
                    items: items,
                    itemAsString: (value) => value.name ?? '',
                    selectedItem: state.isChangedCity == true ||
                            state.isChangedProvince == true
                        ? null
                        : state.districtEntity,
                    onChanged: (value) {
                      context.read<AddressDataCubit>().changeDistrict(value);
                    },
                    state: dsState,
                    errorMessage: state.districtErrMessage ?? '',
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          BlocBuilder<AddressDataCubit, AddressDataState>(
            buildWhen: (previous, current) =>
                previous.isPostalCodeError != current.isPostalCodeError ||
                previous.postalCodeErrMessage != current.postalCodeErrMessage,
            builder: (context, state) {
              return MainTextField(
                title: t.lblPostalCode,
                titleColor: clrBackgroundBlack.withOpacity(0.75),
                controller: _postalCodeTec,
                // focusNode: _pobFocus,
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(5),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputType: TextInputType.number,
                hintText: t.lblYourPostalCode,
                onFieldSubmitted: (_) {
                  _addressFocus.requestFocus();
                },
                onChange: (value) {
                  final addressData = context.read<AddressDataCubit>().state;
                  if (addressData.isMailSameAsHome) {
                    _mailPostalCodeTec.text = _postalCodeTec.text;
                  }

                  context
                      .read<AddressDataCubit>()
                      .validatePostalCode(t: t, value: _postalCodeTec.text);
                },
                isError: state.isPostalCodeError ?? false,
                errorText: state.postalCodeErrMessage ?? '',
                isDarkMode: false,
              );
            },
          ),
          const SizedBox(height: 18),
          BlocBuilder<AddressDataCubit, AddressDataState>(
            buildWhen: (previous, current) =>
                previous.isAddressError != current.isAddressError ||
                previous.addressErrMessage != current.addressErrMessage,
            builder: (context, state) {
              return MainTextField(
                title: t.lblAddress,
                titleColor: clrBackgroundBlack.withOpacity(0.75),
                controller: _addressTec,
                focusNode: _addressFocus,
                hintText: t.lblYourAddress,
                onFieldSubmitted: (_) {
                  // _dobFocus.requestFocus();
                },
                onChange: (value) {
                  final addressData = context.read<AddressDataCubit>().state;
                  if (addressData.isMailSameAsHome) {
                    _mailAddressTec.text = _addressTec.text;
                  }

                  context
                      .read<AddressDataCubit>()
                      .validateAddress(t: t, value: _addressTec.text);
                },
                isError: state.isAddressError ?? false,
                errorText: state.addressErrMessage ?? '',
                isDarkMode: false,
                isAddress: true,
              );
            },
          ),
        ],
      );

  Widget _mailField(AppLocalizations t) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<MailProvinceBloc, ProvinceState>(
            builder: (context, provState) {
              List<ProvinceEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (provState is ProvinceLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (provState is ProvinceSuccessState) {
                dsState = MainDropdownSearchState.active;
                items = provState.data;
              }
              return BlocBuilder<AddressDataCubit, AddressDataState>(
                buildWhen: (previous, current) =>
                    previous != current ||
                    previous.mailProvinceErrMessage !=
                        current.mailProvinceErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<ProvinceEntity>(
                    title: t.lblProvince,
                    hintText: '${t.lblSelect} ${t.lblProvince}',
                    items: items,
                    selectedItem: state.mailProvinceEntity,
                    itemAsString: (value) => value.name ?? '',
                    onChanged: (value) {
                      context
                          .read<AddressDataCubit>()
                          .changeMailProvince(value);
                      context
                          .read<MailCityBloc>()
                          .add(CityGetEvent(provinceId: value?.id));
                      context
                          .read<MailDistrictBloc>()
                          .add(DistrictBackToInitEvent());
                    },
                    state: dsState,
                    errorMessage: state.mailProvinceErrMessage ?? '',
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          BlocBuilder<MailCityBloc, CityState>(
            builder: (context, provState) {
              List<CityEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (provState is CityLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (provState is CitySuccessState) {
                dsState = MainDropdownSearchState.active;
                items = provState.data;
              }
              return BlocBuilder<AddressDataCubit, AddressDataState>(
                buildWhen: (previous, current) =>
                    previous != current ||
                    previous.mailCityErrMessage != current.mailCityErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<CityEntity>(
                    title: t.lblCity,
                    hintText: '${t.lblSelect} ${t.lblCity}',
                    items: items,
                    selectedItem: state.isChangedMailProvince == true
                        ? null
                        : state.mailCityEntity,
                    itemAsString: (value) => value.city ?? '',
                    onChanged: (value) {
                      context.read<AddressDataCubit>().changeMailCity(value);
                      context
                          .read<MailDistrictBloc>()
                          .add(DistrictGetEvent(cityId: value?.id));
                    },
                    state: dsState,
                    errorMessage: state.mailCityErrMessage ?? '',
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          BlocBuilder<MailDistrictBloc, DistrictState>(
            builder: (context, provState) {
              List<DistrictEntity> items = const [];
              var dsState = MainDropdownSearchState.disabled;
              if (provState is DistrictLoadingState) {
                dsState = MainDropdownSearchState.loading;
                items = const [];
              }
              if (provState is DistrictSuccessState) {
                dsState = MainDropdownSearchState.active;
                items = provState.data;
              }
              return BlocBuilder<AddressDataCubit, AddressDataState>(
                buildWhen: (previous, current) =>
                    previous != current ||
                    previous.mailDistrictErrMessage !=
                        current.mailDistrictErrMessage,
                builder: (context, state) {
                  return MainDropDownSearch<DistrictEntity>(
                    title: t.lblDistrict,
                    hintText: '${t.lblSelect} ${t.lblDistrict}',
                    items: items,
                    selectedItem: state.isChangedMailCity == true ||
                            state.isChangedMailProvince == true
                        ? null
                        : state.mailDistrictEntity,
                    itemAsString: (value) => value.name ?? '',
                    onChanged: (value) {
                      context
                          .read<AddressDataCubit>()
                          .changeMailDistrict(value);
                    },
                    state: dsState,
                    errorMessage: state.mailDistrictErrMessage ?? '',
                  );
                },
              );
            },
          ),
          const SizedBox(height: 18),
          BlocBuilder<AddressDataCubit, AddressDataState>(
            buildWhen: (previous, current) =>
                previous.isMailPostalCodeError !=
                    current.isMailPostalCodeError ||
                previous.mailPostalCodeErrMessage !=
                    current.mailPostalCodeErrMessage,
            builder: (context, state) {
              return MainTextField(
                title: t.lblPostalCode,
                titleColor: clrBackgroundBlack.withOpacity(0.75),
                controller: _mailPostalCodeTec,
                // focusNode: _pobFocus,
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(5),
                  FilteringTextInputFormatter.digitsOnly
                ],
                textInputType: TextInputType.number,
                hintText: 'Masukkan kode pos',
                onFieldSubmitted: (_) {
                  _mailAddressFocus.requestFocus();
                },
                onChange: (value) {
                  context.read<AddressDataCubit>().validateMailPostalCode(
                      t: t, value: _mailPostalCodeTec.text);
                },
                isError: state.isMailPostalCodeError ?? false,
                errorText: state.mailPostalCodeErrMessage ?? '',
                isDarkMode: false,
              );
            },
          ),
          const SizedBox(height: 18),
          BlocBuilder<AddressDataCubit, AddressDataState>(
            buildWhen: (previous, current) =>
                previous.isMailAddressError != current.isMailAddressError ||
                previous.mailAddressErrMessage != current.mailAddressErrMessage,
            builder: (context, state) {
              return MainTextField(
                title: t.lblAddress,
                titleColor: clrBackgroundBlack.withOpacity(0.75),
                controller: _mailAddressTec,
                focusNode: _mailAddressFocus,
                hintText: 'Masukkan alamat',
                onFieldSubmitted: (_) {
                  // _dobFocus.requestFocus();
                },
                onChange: (value) {
                  context
                      .read<AddressDataCubit>()
                      .validateAddressMail(t: t, value: _mailAddressTec.text);
                },
                isError: state.isMailAddressError ?? false,
                errorText: state.mailAddressErrMessage ?? '',
                isDarkMode: false,
                isAddress: true,
              );
            },
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblAddress,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.profileSelfData,
                extra: {'bloc': context.read<ProfileBloc>()});
          },
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: MainButton(
      //     label: t.lblSave,
      //     onPressed: () {
      //       final addressDataState = context.read<AddressDataCubit>().state;
      //       appPrint('---Home Address---');
      //       final homeProvinceId = addressDataState.provinceEntity?.id;
      //       final homeProvinceName = addressDataState.provinceEntity?.name;
      //       final homeCityId = addressDataState.cityEntity?.id;
      //       final homeCityName = addressDataState.cityEntity?.city;
      //       final homeDistrictId = addressDataState.districtEntity?.id;
      //       final homeDistrictName = addressDataState.districtEntity?.name;
      //       final homePostalCode = _postalCodeTec.text;
      //       final homeAddress = _addressTec.text;
      //       appPrint('province: $homeProvinceId - $homeProvinceName');
      //       appPrint('city: $homeCityId - $homeCityName');
      //       appPrint('district: $homeDistrictId - $homeDistrictName');
      //       appPrint('postal code: $homePostalCode');
      //       appPrint('address: $homeAddress');
      //       appPrint('---Mail Address---');
      //       final mailProvinceId = addressDataState.mailProvinceEntity?.id;
      //       final mailProvinceName = addressDataState.mailProvinceEntity?.name;
      //       final mailCityId = addressDataState.mailCityEntity?.id;
      //       final mailCityName = addressDataState.mailCityEntity?.city;
      //       final mailDistrictId = addressDataState.mailDistrictEntity?.id;
      //       final mailDistrictName = addressDataState.mailDistrictEntity?.name;
      //       final mailPostalCode = _mailPostalCodeTec.text;
      //       final mailAddress = _mailAddressTec.text;
      //       appPrint('isMailSameAsHome: ${addressDataState.isMailSameAsHome}');
      //       appPrint('province: $mailProvinceId - $mailProvinceName');
      //       appPrint('city: $mailCityId - $mailCityName');
      //       appPrint('district: $mailDistrictId - $mailDistrictName');
      //       appPrint('postal code: $mailPostalCode');
      //       appPrint('address: $mailAddress');

      //       List<UpdateAddressEntity> dataReq = [];
      //       bool isHomeValidated = homeDistrictId != null &&
      //           homeAddress.isNotEmpty &&
      //           _postalCodeTec.text.isNotEmpty;
      //       if (isHomeValidated) {
      //         dataReq.add(UpdateAddressEntity(
      //           districtId: homeDistrictId,
      //           address: homeAddress,
      //           postalCode: homePostalCode,
      //           type: 'home',
      //         ));
      //         appPrint('home address added');
      //       }

      //       bool isMailValidated = mailDistrictId != null &&
      //           mailAddress.isNotEmpty &&
      //           _mailPostalCodeTec.text.isNotEmpty;
      //       if (isMailValidated) {
      //         dataReq.add(UpdateAddressEntity(
      //           districtId: mailDistrictId,
      //           address: mailAddress,
      //           postalCode: mailPostalCode,
      //           type: 'mailing',
      //         ));
      //         appPrint('mail address added');
      //       }

      //       if (dataReq.isNotEmpty) {
      //         context
      //             .read<ProfileAddressUpdateBloc>()
      //             .add(ProfileAddressUpdatePressed(dataReq));
      //       }
      //     },
      //   ),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    t.lblHomeAddress,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: clrDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _homeField(context, t, initialProvinceId, initialCityId,
                      initialDistrictId),
                  const SizedBox(height: 20),
                  Text(
                    t.lblMailingAddress,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: clrDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  MainCheckbox(
                    initialValue: false,
                    uncheckColor: clrBackgroundBlack.withOpacity(0.08),
                    rightWidget: Text(
                      t.lblMatchHomeAddress,
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: clrBackgroundBlack.withOpacity(0.75),
                      ),
                    ),
                    onChange: (value) {
                      context
                          .read<AddressDataCubit>()
                          .changeIsMailSameAsHome(value);
                      context
                          .read<AddressDataCubit>()
                          .validateHomeAddress(t: t);
                      context
                          .read<AddressDataCubit>()
                          .validatePostalCode(t: t, value: _postalCodeTec.text);
                      context
                          .read<AddressDataCubit>()
                          .validateAddress(t: t, value: _addressTec.text);

                      final isValidated =
                          context.read<AddressDataCubit>().isValidated;
                      if (value && isValidated) {
                        final addressDataState =
                            context.read<AddressDataCubit>().state;
                        context.read<MailCityBloc>().add(CityGetEvent(
                            provinceId:
                                addressDataState.mailProvinceEntity?.id));
                        context.read<MailDistrictBloc>().add(DistrictGetEvent(
                            cityId: addressDataState.mailCityEntity?.id));
                        _mailPostalCodeTec.text = _postalCodeTec.text;
                        _mailAddressTec.text = _addressTec.text;
                      } else {
                        context.read<AddressDataCubit>().state;
                        context.read<MailCityBloc>().add(CityBackToInitEvent());
                        context
                            .read<MailDistrictBloc>()
                            .add(DistrictBackToInitEvent());
                        _mailPostalCodeTec.text = '';
                        _mailAddressTec.text = '';
                        // context.read<AddressDataCubit>().resetMailAddress();
                      }
                    },
                  ),
                  Divider(
                    height: 40,
                    thickness: 1.5,
                    color: clrBackgroundBlack.withOpacity(0.08),
                  ),
                  BlocBuilder<AddressDataCubit, AddressDataState>(
                    builder: (context, state) {
                      if (state.isMailSameAsHome) return const SizedBox();
                      return _mailField(t);
                    },
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: MainButton(
                label: t.lblSave,
                onPressed: () {
                  final addressDataState =
                      context.read<AddressDataCubit>().state;
                  appPrint('---Home Address---');
                  final homeProvinceId = addressDataState.provinceEntity?.id;
                  final homeProvinceName =
                      addressDataState.provinceEntity?.name;
                  final homeCityId = addressDataState.cityEntity?.id;
                  final homeCityName = addressDataState.cityEntity?.city;
                  final homeDistrictId = addressDataState.districtEntity?.id;
                  final homeDistrictName =
                      addressDataState.districtEntity?.name;
                  final homePostalCode = _postalCodeTec.text;
                  final homeAddress = _addressTec.text;
                  appPrint('province: $homeProvinceId - $homeProvinceName');
                  appPrint('city: $homeCityId - $homeCityName');
                  appPrint('district: $homeDistrictId - $homeDistrictName');
                  appPrint('postal code: $homePostalCode');
                  appPrint('address: $homeAddress');
                  appPrint('---Mail Address---');
                  final mailProvinceId =
                      addressDataState.mailProvinceEntity?.id;
                  final mailProvinceName =
                      addressDataState.mailProvinceEntity?.name;
                  final mailCityId = addressDataState.mailCityEntity?.id;
                  final mailCityName = addressDataState.mailCityEntity?.city;
                  final mailDistrictId =
                      addressDataState.mailDistrictEntity?.id;
                  final mailDistrictName =
                      addressDataState.mailDistrictEntity?.name;
                  final mailPostalCode = _mailPostalCodeTec.text;
                  final mailAddress = _mailAddressTec.text;
                  appPrint(
                      'isMailSameAsHome: ${addressDataState.isMailSameAsHome}');
                  appPrint('province: $mailProvinceId - $mailProvinceName');
                  appPrint('city: $mailCityId - $mailCityName');
                  appPrint('district: $mailDistrictId - $mailDistrictName');
                  appPrint('postal code: $mailPostalCode');
                  appPrint('address: $mailAddress');

                  List<UpdateAddressEntity> dataReq = [];
                  bool isHomeValidated = homeDistrictId != null &&
                      homeAddress.isNotEmpty &&
                      _postalCodeTec.text.isNotEmpty;
                  if (isHomeValidated) {
                    dataReq.add(UpdateAddressEntity(
                      districtId: homeDistrictId,
                      address: homeAddress,
                      postalCode: homePostalCode,
                      type: 'home',
                    ));
                    appPrint('home address added');
                  }

                  bool isMailValidated = mailDistrictId != null &&
                      mailAddress.isNotEmpty &&
                      _mailPostalCodeTec.text.isNotEmpty;
                  if (isMailValidated) {
                    dataReq.add(UpdateAddressEntity(
                      districtId: mailDistrictId,
                      address: mailAddress,
                      postalCode: mailPostalCode,
                      type: 'mailing',
                    ));
                    appPrint('mail address added');
                  }

                  context.read<AddressDataCubit>().validateHomeAddress(t: t);
                  context.read<AddressDataCubit>().validatedMailAddress(t: t);
                  context
                      .read<AddressDataCubit>()
                      .validatePostalCode(t: t, value: _postalCodeTec.text);
                  context
                      .read<AddressDataCubit>()
                      .validateAddress(t: t, value: _addressTec.text);

                  context.read<AddressDataCubit>().validateMailPostalCode(
                      t: t, value: _mailPostalCodeTec.text);
                  context
                      .read<AddressDataCubit>()
                      .validateAddressMail(t: t, value: _mailAddressTec.text);

                  final isValidated =
                      context.read<AddressDataCubit>().isValidated;

                  final isValidatedMail =
                      context.read<AddressDataCubit>().isValidatedMail;

                  if (!dataReq.isNotEmpty || !isValidated || !isValidatedMail) {
                    DialogUtils.universal(
                      context: context,
                      barrierDismissible: true,
                      firstDesc: 'Mohon isi semua kolom dengan benar',
                      icon: Image.asset(icWarningYellow),
                      btnText: t.lblBack,
                      btnConfirm: () {
                        context.pop();
                      },
                    );
                  }

                  if (dataReq.isNotEmpty && isValidated && isValidatedMail) {
                    context
                        .read<ProfileAddressUpdateBloc>()
                        .add(ProfileAddressUpdatePressed(dataReq));
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
