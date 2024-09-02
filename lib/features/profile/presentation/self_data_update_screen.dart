import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../cores/widgets/main_dropdown_search.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_date_picker.dart';
import '../../../cores/widgets/main_dropdown.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../domain/entities/city_entity.dart';
import '../domain/entities/country_entity.dart';
import 'blocs/city/city_bloc.dart';
import 'blocs/city/home/home_city_bloc.dart';
import 'blocs/country/country_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/profile_update/profile_update_bloc.dart';
import 'cubits/self_data_update/self_data_update_cubit.dart';

class SelfDataUpdateScreen extends StatelessWidget {
  const SelfDataUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SelfDataUpdateCubit>()..initSelfData(),
        ),
        BlocProvider(
          create: (context) => sl<ProfileUpdateBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<HomeCityBloc>()
            ..add(const CityGetEvent(
              limit: 10000,
              page: 1,
            )),
        ),
        BlocProvider(
          create: (context) => sl<CountryBloc>()
            ..add(const CountryGetEvent(
              limit: 10000,
              page: 1,
            )),
        ),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
      listener: (context, state) {
        if (state is ProfileUpdateLoadingState) {
          EasyLoading.show();
        }
        if (state is ProfileUpdateSuccessState) {
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
        if (state is ProfileUpdateFailureState) {
          EasyLoading.showError(
            errorMessage(state.appFailure) ?? t.lblSomethingWrong,
            dismissOnTap: true,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: clrBlack101,
          centerTitle: true,
          title: Text(
            t.lblSelfData,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: MainBackButton(
            onPressed: () {
              _goToPofileSelfData(context);
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: _mainButton(t, context),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 32),
                BlocBuilder<SelfDataUpdateCubit, SelfDataUpdateState>(
                  buildWhen: (previous, current) =>
                      previous.userDataEntity?.name !=
                          current.userDataEntity?.name ||
                      previous.isNameError != current.isNameError,
                  builder: (context, state) {
                    return MainTextField(
                      title: t.lblFullName,
                      titleColor: clrBackgroundBlack.withOpacity(0.75),
                      controller: TextEditingController(text: state.fullName),
                      hintText: t.lblWhatsYourFullName,
                      onChange: (value) => context
                          .read<SelfDataUpdateCubit>()
                          .changeFullName(value),
                      onFieldSubmitted: (_) {
                        // _genderFocus.requestFocus();
                      },
                      isError: state.isNameError ?? false,
                      errorText: state.isNameErrorMessage ?? '',
                      isDarkMode: false,
                      enabled: false,
                    );
                  },
                ),
                const SizedBox(height: 18),
                BlocBuilder<SelfDataUpdateCubit, SelfDataUpdateState>(
                  buildWhen: (previous, current) =>
                      previous.userDataEntity?.gender !=
                          current.userDataEntity?.gender ||
                      previous.genderErrorMessage != current.genderErrorMessage,
                  builder: (context, state) {
                    return MainDropDown<String>(
                      title: t.lblGender,
                      hintText: '${t.lblSelect} ${t.lblGender}',
                      items: context.read<SelfDataUpdateCubit>().genders,
                      itemName: (val) => val,
                      value: context
                          .read<SelfDataUpdateCubit>()
                          .genders
                          .where((element) => element == state.gender)
                          .toList()
                          .asMap()[0],
                      onChange: (value) => context
                          .read<SelfDataUpdateCubit>()
                          .changeGender(value),
                      errorMessage: state.genderErrorMessage ?? '',
                      enabled: (state.gender ?? '').isEmpty,
                    );
                  },
                ),
                const SizedBox(height: 18),
                BlocBuilder<CountryBloc, CountryState>(
                    builder: (context, countryState) {
                  List<CountryEntity> data = [];
                  MainDropdownSearchState mdds =
                      MainDropdownSearchState.loading;
                  if (countryState is CountrySuccessState) {
                    data = countryState.data;
                    mdds = (context
                                    .read<SelfDataUpdateCubit>()
                                    .state
                                    .userDataEntity
                                    ?.countryOfBirth ??
                                "")
                            .isEmpty
                        ? MainDropdownSearchState.active
                        : MainDropdownSearchState.disabled;
                  }
                  return MainDropDownSearch(
                    isElite: false,
                    title: "Negara Kelahiran",
                    hintText: "Di negara mana kamu lahir?",
                    state: mdds,
                    itemAsString: (p0) => p0.name ?? "-",
                    items: data,
                    onChanged: (value) => context
                        .read<SelfDataUpdateCubit>()
                        .changeCob(value?.name ?? ""),
                    selectedItem: data
                        .where((element) =>
                            element.name ==
                            context.read<SelfDataUpdateCubit>().state.cob)
                        .firstOrNull,
                  );
                }),
                const SizedBox(height: 18),
                BlocBuilder<SelfDataUpdateCubit, SelfDataUpdateState>(
                    buildWhen: (previous, current) =>
                        previous.cob != current.cob ||
                        previous.userDataEntity?.placeOfBirth !=
                            current.userDataEntity?.placeOfBirth ||
                        previous.isPobError != current.isPobError,
                    builder: (context, state) {
                      if (state.cob?.toLowerCase() == "indonesia") {
                        return BlocBuilder<HomeCityBloc, CityState>(
                            builder: (context, cityState) {
                          List<CityEntity> data = [];
                          MainDropdownSearchState mdds =
                              MainDropdownSearchState.loading;
                          if (cityState is CitySuccessState) {
                            data = cityState.data;
                            mdds = (state.userDataEntity?.placeOfBirth ?? "")
                                    .isEmpty
                                ? MainDropdownSearchState.active
                                : MainDropdownSearchState.disabled;
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MainDropDownSearch<CityEntity>(
                                isElite: false,
                                title: t.lblPlaceOfBirth,
                                hintText: t.lblWhichCityYouBorn,
                                state: mdds,
                                itemAsString: (p0) => p0.city ?? "-",
                                items: data,
                                onChanged: (value) => context
                                    .read<SelfDataUpdateCubit>()
                                    .changePob(
                                        value?.city ?? value?.name ?? ""),
                                selectedItem: data
                                    .where(
                                        (element) => element.city == state.pob)
                                    .firstOrNull,
                              ),
                              const SizedBox(height: 18),
                            ],
                          );
                        });
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MainTextField(
                            title: t.lblPlaceOfBirth,
                            titleColor: clrBackgroundBlack.withOpacity(0.75),
                            initialValue: context
                                .read<HelperDataCubit>()
                                .state
                                .userDataEntity
                                ?.placeOfBirth,
                            hintText: t.lblWhichCityYouBorn,
                            onChange: (value) => context
                                .read<SelfDataUpdateCubit>()
                                .changePob(value),
                            onFieldSubmitted: (_) {
                              // _dobFocus.requestFocus();
                            },
                            isError: state.isPobError ?? false,
                            errorText: state.isPobErrorMessage ?? '',
                            isDarkMode: false,
                            // enabled: (state.pob ?? '').isEmpty,
                            enabled: (context
                                        .read<HelperDataCubit>()
                                        .state
                                        .userDataEntity
                                        ?.placeOfBirth ??
                                    "")
                                .isEmpty,
                          ),
                          const SizedBox(height: 18),
                        ],
                      );
                    }),
                BlocBuilder<SelfDataUpdateCubit, SelfDataUpdateState>(
                  buildWhen: (previous, current) =>
                      previous.userDataEntity?.dateOfBirth !=
                      current.userDataEntity?.dateOfBirth,
                  builder: (context, state) {
                    String? dateTimeFormated;
                    if ((state.dob ?? "").isNotEmpty) {
                      DateTime dateTime;
                      try {
                        dateTime = DateTime.parse(state.dob!);
                      } catch (e) {
                        dateTime = DateFormat("dd-mm-yyyy").parse(state.dob!);
                      }
                      dateTimeFormated =
                          DateFormat('dd/MM/yyyy').format(dateTime);
                    }
                    return MainDatePicker(
                      title: '${t.lblDateOfBirth} (dd/MM/yyyy)',
                      titleColor: clrBackgroundBlack.withOpacity(0.75),
                      hintText: (dateTimeFormated ?? '').isNotEmpty
                          ? dateTimeFormated
                          : '${t.lblSelect} ${t.lblDateOfBirth}',
                      onChanged: (value) {
                        final strDate = value != null
                            ? DateFormat('dd-MM-yyyy').format(value)
                            : null;
                        context
                            .read<SelfDataUpdateCubit>()
                            .changeDob(strDate ?? '');
                      },
                      enabled: (dateTimeFormated ?? '').isEmpty,
                    );
                  },
                ),
                const SizedBox(height: 18),
                BlocBuilder<SelfDataUpdateCubit, SelfDataUpdateState>(
                    buildWhen: (previous, current) =>
                        previous.userDataEntity?.maritalStatus !=
                            current.userDataEntity?.maritalStatus ||
                        previous.maritalErrorMessage !=
                            current.maritalErrorMessage,
                    builder: (context, state) {
                      return MainDropDown<String>(
                        title: t.lblMaritalStatus,
                        hintText: '${t.lblSelect} ${t.lblMaritalStatus}',
                        items:
                            context.read<SelfDataUpdateCubit>().maritalStatuses,
                        itemName: (val) => val,
                        value: context
                            .read<SelfDataUpdateCubit>()
                            .maritalStatuses
                            .where((element) => element == state.maritalStatus)
                            .toList()
                            .asMap()[0],
                        onChange: (value) => context
                            .read<SelfDataUpdateCubit>()
                            .changeMaritalStatus(value),
                        errorMessage: state.maritalErrorMessage ?? '',
                      );
                    }),
                const SizedBox(height: 18),
                BlocBuilder<SelfDataUpdateCubit, SelfDataUpdateState>(
                    buildWhen: (previous, current) =>
                        previous.userDataEntity?.religion !=
                            current.userDataEntity?.religion ||
                        previous.religionErrorMessage !=
                            current.religionErrorMessage,
                    builder: (context, state) {
                      return MainDropDown<String>(
                        title: t.lblReligion,
                        hintText: '${t.lblSelect} ${t.lblReligion}',
                        items: context.read<SelfDataUpdateCubit>().religions,
                        itemName: (val) => val,
                        value: context
                            .read<SelfDataUpdateCubit>()
                            .religions
                            .where((element) => element == state.religion)
                            .toList()
                            .asMap()[0],
                        onChange: (value) => context
                            .read<SelfDataUpdateCubit>()
                            .changeReligion(value),
                        errorMessage: state.religionErrorMessage ?? '',
                      );
                    }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goToPofileSelfData(BuildContext context) {
    context.goNamed(
      AppRoutes.profileSelfData,
      extra: {'bloc': context.read<ProfileBloc>()},
    );
  }

  Widget _mainButton(AppLocalizations t, BuildContext context) {
    return BlocBuilder<SelfDataUpdateCubit, SelfDataUpdateState>(
      buildWhen: (previous, current) =>
          previous.fullName != current.fullName ||
          previous.gender != current.gender ||
          previous.cob != current.cob ||
          previous.pob != current.pob ||
          previous.dob != current.dob ||
          previous.maritalStatus != current.maritalStatus ||
          previous.religion != current.religion,
      builder: (context, state) {
        bool isFullNameUpdated = state.userDataEntity?.name != state.fullName;
        bool isGenderUpdated = state.userDataEntity?.gender != state.gender;
        // bool isCobUpdated = state.userDataEntity?.countryOfBirth != state.cob;
        bool isPobUpdated = (state.userDataEntity?.placeOfBirth != state.pob) &&
            (state.cob ?? "").isNotEmpty;
        bool isDobUpdated = state.userDataEntity?.dateOfBirth != state.dob;
        bool isMaritalStatusUpdated =
            state.userDataEntity?.maritalStatus != state.maritalStatus;
        bool isReligionUpdated =
            state.userDataEntity?.religion != state.religion;

        return MainButton(
          label: t.lblSave,
          onPressed: isFullNameUpdated ||
                  isGenderUpdated ||
                  isPobUpdated ||
                  isDobUpdated ||
                  isMaritalStatusUpdated ||
                  isReligionUpdated
              ? () {
                  appPrint(
                      'fullname old: ${context.read<SelfDataUpdateCubit>().state.userDataEntity?.name}, new: ${context.read<SelfDataUpdateCubit>().state.fullName}');
                  appPrint(
                      'gender old: ${context.read<SelfDataUpdateCubit>().state.userDataEntity?.gender}, new: ${context.read<SelfDataUpdateCubit>().state.gender}');
                  appPrint(
                      'cob old: ${context.read<SelfDataUpdateCubit>().state.userDataEntity?.countryOfBirth}, new: ${context.read<SelfDataUpdateCubit>().state.cob}');
                  appPrint(
                      'pob old: ${context.read<SelfDataUpdateCubit>().state.userDataEntity?.placeOfBirth}, new: ${context.read<SelfDataUpdateCubit>().state.pob}');
                  appPrint(
                      'dob old: ${context.read<SelfDataUpdateCubit>().state.userDataEntity?.dateOfBirth}, new: ${context.read<SelfDataUpdateCubit>().state.dob}');
                  appPrint(
                      'marital old: ${context.read<SelfDataUpdateCubit>().state.userDataEntity?.maritalStatus}, new: ${context.read<SelfDataUpdateCubit>().state.maritalStatus}');
                  appPrint(
                      'religion old: ${context.read<SelfDataUpdateCubit>().state.userDataEntity?.religion}, new: ${context.read<SelfDataUpdateCubit>().state.religion}');
                  context.read<SelfDataUpdateCubit>().validate(
                        t: t,
                        onValidated: () {
                          context
                              .read<ProfileUpdateBloc>()
                              .add(SelfDataUpdatePressed(
                                fullName: context
                                    .read<SelfDataUpdateCubit>()
                                    .state
                                    .fullName,
                                gender: context
                                    .read<SelfDataUpdateCubit>()
                                    .state
                                    .gender,
                                cob: context
                                    .read<SelfDataUpdateCubit>()
                                    .state
                                    .cob,
                                pob: context
                                    .read<SelfDataUpdateCubit>()
                                    .state
                                    .pob,
                                dob: context
                                    .read<SelfDataUpdateCubit>()
                                    .state
                                    .dob,
                                maritalStatus: context
                                    .read<SelfDataUpdateCubit>()
                                    .state
                                    .maritalStatus,
                                religion: context
                                    .read<SelfDataUpdateCubit>()
                                    .state
                                    .religion,
                              ));
                        },
                      );
                }
              : null,
        );
      },
    );
  }
}
