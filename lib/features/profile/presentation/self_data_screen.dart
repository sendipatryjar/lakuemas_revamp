import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/widgets/card_list_widget.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/user/domain/entities/user_data_address_entity.dart';
import '../../_core/user/domain/entities/user_data_entity.dart';
import '../domain/entities/detail_district_entity.dart';
import 'blocs/detail_district/detail_district_bloc.dart';
import 'blocs/detail_district/home/home_district_bloc.dart';
import 'blocs/detail_district/mail/mail_district_bloc.dart';
import 'blocs/profile/profile_bloc.dart';

class SelfDataScreen extends StatelessWidget {
  final int? initialDistrctId;
  final int? initialMailDistrictId;
  const SelfDataScreen({
    super.key,
    this.initialDistrctId,
    this.initialMailDistrictId,
  });

  void _goToAddressUpdate(BuildContext context) {
    context.goNamed(AppRoutes.addressUpdate,
        extra: {'bloc': context.read<ProfileBloc>()});
  }

  void _goToIncomeDataUpdate(BuildContext context) {
    context.goNamed(AppRoutes.incomeDataUpdate,
        extra: {'bloc': context.read<ProfileBloc>()});
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        initialDistrctId != null
            ? BlocProvider(
                create: (context) => sl<HomeDetailDistrictBloc>()
                  ..add(DetailDistrictGetEvent(
                    id: initialDistrctId,
                    helperDataCubit: context.read<HelperDataCubit>(),
                  )),
              )
            : BlocProvider(
                create: (context) => sl<HomeDetailDistrictBloc>(),
              ),
        initialMailDistrictId != null
            ? BlocProvider(
                create: (context) => sl<MailDetailDistrictBloc>()
                  ..add(DetailDistrictGetEvent(
                    id: initialMailDistrictId,
                    helperDataCubit: context.read<HelperDataCubit>(),
                  )),
              )
            : BlocProvider(create: (context) => sl<MailDetailDistrictBloc>()),
      ],
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
              context.goNamed(AppRoutes.profile);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProfileSuccessState) {
                  DetailDistrictEntity? homeDetailDistrictData;
                  var homeDetailDistrictState =
                      context.watch<HomeDetailDistrictBloc>().state;
                  if (homeDetailDistrictState is DetailDistrictSuccessState) {
                    homeDetailDistrictData = homeDetailDistrictState.data;
                  }
                  DetailDistrictEntity? mailDetailDistrictData;
                  var mailDetailDistrictState =
                      context.watch<MailDetailDistrictBloc>().state;
                  if (mailDetailDistrictState is DetailDistrictSuccessState) {
                    mailDetailDistrictData = mailDetailDistrictState.data;
                  }
                  return Column(
                    children: [
                      _section(
                        context: context,
                        t: t,
                        title: t.lblPersonalData,
                        itemLength: 6,
                        itemTitle: (index) => _personalItemTitle(t, index),
                        itemSubTitle: (index) =>
                            _personalItemSubTitle(state.userDataEntity, index),
                        rightButton: SizedBox(
                          height: 24,
                          child: MainButton(
                            label: '${t.lblEdit} ${t.lblPersonalData}',
                            labelStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: clrDarkBrown,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            bgColor: clrYellow,
                            borderRadius: 30,
                            onPressed: () {
                              context.goNamed(
                                AppRoutes.selfDataUpdate,
                                extra: {'bloc': context.read<ProfileBloc>()},
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // _section(
                      //   context: context,
                      //   t: t,
                      //   title: t.lblEmail,
                      //   itemLength: 1,
                      //   itemTitle: (index) => '${t.lblEmail} ${t.lblUsed}',
                      //   itemSubTitle: (index) =>
                      //       state.userDataEntity?.email ?? '-',
                      // ),
                      // const SizedBox(height: 20),
                      // _section(
                      //   context: context,
                      //   t: t,
                      //   title: t.lblPhoneNumber,
                      //   itemLength: 1,
                      //   itemTitle: (index) => '${t.lblPhoneNumber} ${t.lblUsed}',
                      //   itemSubTitle: (index) =>
                      //       state.userDataEntity?.handphone ?? '-',
                      // ),
                      // const SizedBox(height: 20),
                      // _section(
                      //   context: context,
                      //   t: t,
                      //   title: t.lblAddress,
                      //   itemLength: 1,
                      //   itemTitle: (index) =>
                      //       '${t.lblYouHaveNotEntered} ${t.lblAddress}',
                      //   itemSubTitle: (index) => t.lblFillNow,
                      //   subTitleTextDecoration: TextDecoration.underline,
                      //   onTap: (index) {
                      //     _goToAddressUpdate(context);
                      //   },
                      // ),
                      _section(
                        context: context,
                        t: t,
                        title: t.lblAddress,
                        rightButton: (state.userDataEntity
                                        ?.userDataAddressEntity ??
                                    [])
                                .isNotEmpty
                            ? SizedBox(
                                height: 24,
                                child: MainButton(
                                  label: t.lblEdit,
                                  labelStyle: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: clrDarkBrown,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  bgColor: clrYellow,
                                  borderRadius: 30,
                                  onPressed: () {
                                    context.goNamed(
                                      AppRoutes.addressUpdate,
                                      extra: {
                                        'bloc': context.read<ProfileBloc>(),
                                        'initialProvinceId': (context
                                                    .read<HomeDetailDistrictBloc>()
                                                    .state
                                                as DetailDistrictSuccessState)
                                            .data
                                            .city
                                            ?.province
                                            ?.id,
                                        'initialCityId': (context
                                                    .read<HomeDetailDistrictBloc>()
                                                    .state
                                                as DetailDistrictSuccessState)
                                            .data
                                            .city
                                            ?.id,
                                        'initialDistrictId': state
                                            .userDataEntity
                                            ?.userDataAddressEntity?[0]
                                            .districtId,
                                        'initPostalCode': state
                                            .userDataEntity
                                            ?.userDataAddressEntity?[0]
                                            .postalCode,
                                        'initHomeAddress': state.userDataEntity
                                            ?.userDataAddressEntity?[0].address,
                                        //
                                        'initMailProvinceId': (context
                                                    .read<MailDetailDistrictBloc>()
                                                    .state
                                                as DetailDistrictSuccessState)
                                            .data
                                            .city
                                            ?.province
                                            ?.id,
                                        'initMailCityId': (context
                                                    .read<MailDetailDistrictBloc>()
                                                    .state
                                                as DetailDistrictSuccessState)
                                            .data
                                            .city
                                            ?.id,
                                        'initMailDistrictId': state
                                            .userDataEntity
                                            ?.userDataAddressEntity?[1]
                                            .districtId,
                                        'initMailPostalCode': state
                                            .userDataEntity
                                            ?.userDataAddressEntity?[1]
                                            .postalCode,
                                        'initMailAddress': state.userDataEntity
                                            ?.userDataAddressEntity?[1].address,
                                      },
                                    );
                                  },
                                ),
                              )
                            : null,
                        itemLength: (state.userDataEntity?.userDataAddressEntity
                                        ?.length ??
                                    0) <
                                1
                            ? 1
                            : (state.userDataEntity?.userDataAddressEntity
                                    ?.length ??
                                1),
                        itemTitle: (index) =>
                            (state.userDataEntity?.userDataAddressEntity ?? [])
                                    .isNotEmpty
                                ? _addressItemTitle(
                                    t,
                                    state.userDataEntity!
                                        .userDataAddressEntity![index])
                                : '${t.lblYouHaveNotEntered} ${t.lblAddress}',
                        itemSubTitle: (index) =>
                            (state.userDataEntity?.userDataAddressEntity ?? [])
                                    .isNotEmpty
                                ? _addressItemSubTitle(
                                    state.userDataEntity!
                                        .userDataAddressEntity![index],
                                    homeDetailDistrictData,
                                    mailDetailDistrictData,
                                  )
                                : t.lblFillNow,
                        subTitleTextDecoration:
                            (state.userDataEntity?.userDataAddressEntity ?? [])
                                    .isNotEmpty
                                ? null
                                : TextDecoration.underline,
                        onTap:
                            (state.userDataEntity?.userDataAddressEntity ?? [])
                                    .isNotEmpty
                                ? null
                                : (index) {
                                    _goToAddressUpdate(context);
                                  },
                      ),
                      const SizedBox(height: 20),
                      _section(
                          context: context,
                          t: t,
                          title: t.lblIncomeData,
                          rightButton: (state.userDataEntity?.occupation ?? '').isNotEmpty ||
                                  (state.userDataEntity?.income ?? '')
                                      .isNotEmpty ||
                                  (state.userDataEntity?.purpose ?? '')
                                      .isNotEmpty
                              ? SizedBox(
                                  height: 24,
                                  child: MainButton(
                                    label: t.lblEdit,
                                    labelStyle: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: clrDarkBrown,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    bgColor: clrYellow,
                                    borderRadius: 30,
                                    onPressed: () {
                                      _goToIncomeDataUpdate(context);
                                    },
                                  ),
                                )
                              : null,
                          itemLength: (state.userDataEntity?.occupation ?? '').isNotEmpty || (state.userDataEntity?.income ?? '').isNotEmpty || (state.userDataEntity?.purpose ?? '').isNotEmpty
                              ? 3
                              : 1,
                          itemTitle: (index) =>
                              (state.userDataEntity?.occupation ?? '').isNotEmpty || (state.userDataEntity?.income ?? '').isNotEmpty || (state.userDataEntity?.purpose ?? '').isNotEmpty
                                  ? _incomeItemTitle(t, index)
                                  : '${t.lblYouHaveNotEntered} ${t.lblIncomeData}',
                          itemSubTitle: (index) => (state.userDataEntity?.occupation ?? '').isNotEmpty ||
                                  (state.userDataEntity?.income ?? '')
                                      .isNotEmpty ||
                                  (state.userDataEntity?.purpose ?? '')
                                      .isNotEmpty
                              ? _incomeItemSubTitle(state.userDataEntity, index)
                              : t.lblFillNow,
                          subTitleTextDecoration:
                              (state.userDataEntity?.occupation ?? '').isNotEmpty ||
                                      (state.userDataEntity?.income ?? '').isNotEmpty ||
                                      (state.userDataEntity?.purpose ?? '').isNotEmpty
                                  ? null
                                  : TextDecoration.underline,
                          onTap: (state.userDataEntity?.occupation ?? '').isNotEmpty || (state.userDataEntity?.income ?? '').isNotEmpty || (state.userDataEntity?.purpose ?? '').isNotEmpty
                              ? null
                              : (index) {
                                  _goToIncomeDataUpdate(context);
                                }),
                      const SizedBox(height: 20),
                    ],
                  );
                }

                return Center(
                  child: Text(t.lblSomethingWrong),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _personalItemTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblFullName;
      case 1:
        return t.lblGender;
      case 2:
        return t.lblPlaceOfBirth;
      case 3:
        return t.lblDateOfBirth;
      case 4:
        return t.lblMaritalStatus;
      case 5:
        return t.lblReligion;
      default:
        return '-';
    }
  }

  String _personalItemSubTitle(UserDataEntity? userDataEntity, int index) {
    switch (index) {
      case 0:
        return (userDataEntity?.name ?? '').isNotEmpty
            ? userDataEntity!.name!
            : '-';
      case 1:
        return (userDataEntity?.gender ?? '').isNotEmpty
            ? userDataEntity!.gender!
            : '-';
      case 2:
        return (userDataEntity?.placeOfBirth ?? '').isNotEmpty
            ? userDataEntity!.placeOfBirth!
            : '-';
      case 3:
        return (userDataEntity?.dateOfBirth ?? '').isNotEmpty
            ? userDataEntity!.dateOfBirth!
            : '-';
      case 4:
        return (userDataEntity?.maritalStatus ?? '').isNotEmpty
            ? userDataEntity!.maritalStatus!
            : '-';
      case 5:
        return (userDataEntity?.religion ?? '').isNotEmpty
            ? userDataEntity!.religion!
            : '-';
      default:
        return '-';
    }
  }

  String _addressItemTitle(
      AppLocalizations t, UserDataAddressEntity addressEntity) {
    switch (addressEntity.type) {
      case 'home':
        return t.lblHomeAddress;
      case 'mailing':
        return t.lblMailingAddress;
      default:
        return '-';
    }
  }

  String _addressItemSubTitle(
      UserDataAddressEntity addressEntity,
      DetailDistrictEntity? homeDetailDistrict,
      DetailDistrictEntity? mailDetailDistrict) {
    switch (addressEntity.type) {
      case 'home':
        if (homeDetailDistrict == null) return '-';
        return '${addressEntity.address}, ${homeDetailDistrict.name}, ${homeDetailDistrict.city?.name}, ${homeDetailDistrict.city?.province?.name}, ${addressEntity.postalCode}';
      case 'mailing':
        if (mailDetailDistrict == null) return '-';
        return '${addressEntity.address}, ${mailDetailDistrict.name}, ${mailDetailDistrict.city?.name}, ${mailDetailDistrict.city?.province?.name}, ${addressEntity.postalCode}';
      default:
        return '-';
    }
  }

  String _incomeItemTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblJob;
      case 1:
        return t.lblIncomeType;
      case 2:
        return t.lblAccCreatePurpose;
      default:
        return '-';
    }
  }

  String _incomeItemSubTitle(UserDataEntity? userDataEntity, int index) {
    switch (index) {
      case 0:
        return (userDataEntity?.occupation ?? '').isNotEmpty
            ? userDataEntity!.occupation!
            : '-';
      case 1:
        return (userDataEntity?.income ?? '').isNotEmpty
            ? userDataEntity!.income!
            : '-';
      case 2:
        return (userDataEntity?.purpose ?? '').isNotEmpty
            ? userDataEntity!.purpose!
            : '-';
      default:
        return '-';
    }
  }

  Widget _section({
    required BuildContext context,
    required AppLocalizations t,
    required String title,
    required int itemLength,
    required String Function(int)? itemTitle,
    required String Function(int)? itemSubTitle,
    Widget? rightButton,
    TextDecoration? subTitleTextDecoration,
    Function(int)? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (rightButton != null) rightButton
          ],
        ),
        const SizedBox(height: 16),
        CardListWidget(
          isUseDevider: false,
          isUseRightArrow: false,
          itemLength: itemLength,
          title: itemTitle,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: clrBackgroundBlack.withOpacity(0.5),
          ),
          subTitle: itemSubTitle,
          subTitleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: clrBackgroundBlack,
            decoration: subTitleTextDecoration,
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
