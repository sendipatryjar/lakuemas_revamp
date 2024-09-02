import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/services/secure_storage_service.dart';
import '../../../cores/utils/bottom_sheet_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/label_status_widget.dart';
import '../../../cores/widgets/main_banner.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../../beranda/presentation/blocs/balance/balance_bloc.dart';
import '../../kyc/domain/entities/object_kyc_entity.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/terms_and_conditions_profile/terms_and_conditions_profile_bloc.dart';
import 'widgets/profile_banner_widget.dart';
import 'widgets/profile_email_and_phone_widget.dart';
import 'widgets/profile_section_widget.dart';
import 'widgets/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HelperDataCubit>().updateUserData(null);
            context.read<HelperDataCubit>().updateBalances([]);
            context.read<BerandaBalancesBloc>().add(BerandaBalancesGetEvent(
                  helperDataCubit: context.read<HelperDataCubit>(),
                ));
            context.read<ProfileBloc>().add(ProfileGetDataEvent(
                  eliteCubit: context.read<EliteCubit>(),
                  helperDataCubit: context.read<HelperDataCubit>(),
                ));
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: clrBackgroundBlack,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          ProfileWidget(
                            isElite: isElite,
                          ),
                          const SizedBox(height: 20),
                          const ProfileEmailAndPhoneWidget(),
                          const SizedBox(height: 20),
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              String? email;
                              String? phoneNumber;
                              bool isEmailVerified = false;
                              bool isPhoneNumberVerified = false;
                              bool isAllVeirifed = false;
                              if (state is ProfileSuccessState) {
                                email = state.userDataEntity?.email;
                                phoneNumber = state.userDataEntity?.handphone;
                                isEmailVerified =
                                    state.userDataEntity?.isEmailVerified == 1;
                                isPhoneNumberVerified = state.userDataEntity
                                        ?.isPhoneNumberVerified ==
                                    1;
                                isAllVeirifed =
                                    isEmailVerified && isPhoneNumberVerified;
                              }
                              if ((isAllVeirifed == true) ||
                                  (state is ProfileLoadingState)) {
                                return const SizedBox();
                              }
                              return Column(
                                children: [
                                  MainBanner(
                                    content: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Verifikasi ${(isEmailVerified != true) && (isPhoneNumberVerified != true) ? 'email dan nomor telpon' : isEmailVerified != true ? 'email' : isPhoneNumberVerified != true ? 'nomor telpon' : ''} untuk meningkatkan keamanan akunmu!',
                                          textScaler: TextScaler.linear(
                                              TextUtils.textScaleFactor(
                                                  context)),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: clrWhite,
                                          ),
                                        )),
                                        const SizedBox(width: 8),
                                        MainButton(
                                          label: t.lblVerification,
                                          labelStyle: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: clrWhite,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          bgColor: clrRed,
                                          borderRadius: 30,
                                          onPressed: () {
                                            context.goNamed(
                                                AppRoutes.otpChooseValidate,
                                                extra: {
                                                  'parentScreenName':
                                                      AppRoutes.profile,
                                                  'phoneNumber':
                                                      isPhoneNumberVerified
                                                          ? null
                                                          : phoneNumber,
                                                  'email': isEmailVerified
                                                      ? null
                                                      : email,
                                                });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state is ProfileLoadingState) {
                              return const SizedBox();
                            }
                            int verifyStatus = 0;
                            if (state is ProfileSuccessState) {
                              Map<String, ObjectKycEntity?>? kycData =
                                  state.userDataEntity?.kycEntity?.objectKyc;
                              var ktpStatus = kycData?['ktp']?.status ?? 10;
                              var selfiStatus =
                                  kycData?['selfie']?.status ?? 20;
                              if (ktpStatus == selfiStatus) {
                                verifyStatus = ktpStatus;
                              }
                            }
                            if (verifyStatus == 1) {
                              return const SizedBox();
                            }
                            return const Column(
                              children: [
                                ProfileBannerWidget(),
                                SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            int? initialDistrictId;
                            int? initialMailDistrictId;
                            if (state is ProfileSuccessState) {
                              if ((state.userDataEntity
                                          ?.userDataAddressEntity ??
                                      [])
                                  .isNotEmpty) {
                                initialDistrictId = state
                                        .userDataEntity
                                        ?.userDataAddressEntity?[0]
                                        .districtId ??
                                    0;
                                initialMailDistrictId = state
                                        .userDataEntity
                                        ?.userDataAddressEntity?[1]
                                        .districtId ??
                                    0;
                              }
                            }
                            // return const SizedBox();

                            return ProfileSectionWidget(
                              title: t.lblAccount,
                              itemLength: 2,
                              menuName: (index) => accTitle(t, index),
                              menuOnTap: (index) => accOnTap(context, index,
                                  initialDistrictId, initialMailDistrictId),
                              rightWidget: (index) => accRightWidget(t, index),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        ProfileSectionWidget(
                          title: t.lblSecurity,
                          itemLength: 3,
                          menuName: (index) => securityTitle(t, index),
                          menuOnTap: (index) => securityOnTap(context, index),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<TAndCProfileBloc, TAndCProfileState>(
                          builder: (context, state) {
                            TermsAndConditionsEntity? termsAndConditionsEntity;
                            if (state is TAndCProfileSuccessState) {
                              termsAndConditionsEntity = state.tAndCProfile;
                            }
                            return ProfileSectionWidget(
                              title: '${t.lblAbout} Lakuemas',
                              itemLength: 4,
                              menuName: (index) => aboutTitle(t, index),
                              menuOnTap: (index) => aboutOnTap(
                                context,
                                index,
                                termsAndConditionsEntity,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            DialogUtils.confirm(
                              context: context,
                              barrierDismissible: true,
                              firstDesc: t.lblExitAppConfirm,
                              btnText: t.lblYesExitApp,
                              btnTextLater: t.lblStayToTheApp,
                              btnConfirm: () {
                                context.pop();
                                SecureStorageService()
                                    .logout(context)
                                    .then((value) {
                                  context.goNamed(AppRoutes.login);
                                });
                              },
                              btnLater: () {
                                context.pop();
                              },
                            );
                          },
                          child: Material(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  width: 2,
                                  color: clrRed.withOpacity(0.10),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    clrRed.withOpacity(0.20),
                                    clrRed.withOpacity(0.05),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Keluar',
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      color: clrRed,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: clrBackgroundBlack.withOpacity(0.32),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String accTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblAccountVerification;
      case 1:
        return t.lblSelfData;
      // case 2:
      //   return t.lblRmReferal;
      default:
        return '-';
    }
  }

  void accOnTap(
    BuildContext context,
    int index,
    int? initialDistrictId,
    int? initialMailDistrictId,
  ) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.accountVerification, extra: {
          'isElite': context.read<EliteCubit>().state.toString(),
        });
        break;
      case 1:
        context.goNamed(AppRoutes.profileSelfData, extra: {
          'bloc': context.read<ProfileBloc>(),
          'initialDistrictId': initialDistrictId,
          'initialMailDistrictId': initialMailDistrictId,
        });
        break;
      // case 2:
      //   break;
      default:
    }
  }

  Widget accRightWidget(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const SizedBox();
            }
            int verifyStatus = 0;
            if (state is ProfileSuccessState) {
              Map<String, ObjectKycEntity?>? kycData =
                  state.userDataEntity?.kycEntity?.objectKyc;
              var ktpStatus = kycData?['ktp']?.status ?? 10;
              var selfiStatus = kycData?['selfie']?.status ?? 20;
              if (ktpStatus == selfiStatus) {
                verifyStatus = ktpStatus;
              }
            }
            return LabelStatusWidget(
              text: _kycStatus(t, verifyStatus),
              textColor: _textColor(verifyStatus),
              bgColor: _bgColor(verifyStatus),
              borderColor: _bgColor(verifyStatus),
            );
          },
        );
      default:
        return const SizedBox();
    }
  }

  String securityTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblChangePassword;
      case 1:
        return t.lblChangePin;
      case 2:
        return t.lblSettings;
      default:
        return '-';
    }
  }

  void securityOnTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.changePassword,
            extra: {'bloc': context.read<ProfileBloc>()});
        break;
      case 1:
        context.goNamed(
          AppRoutes.changePin,
          pathParameters: {'backScreen': AppRoutes.profile},
          extra: {'bloc': context.read<ProfileBloc>()},
        );
        break;
      case 2:
        context.goNamed(AppRoutes.settings,
            extra: {'bloc': context.read<ProfileBloc>()});
        break;
      default:
    }
  }

  String aboutTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblSupport;
      case 1:
        return t.lblTermsAndCondition;
      case 2:
        return '${t.lblAbout} ${t.lblUs}';
      case 3:
        return t.lblCloseAccount;
      default:
        return '-';
    }
  }

  void aboutOnTap(
    BuildContext context,
    int index,
    TermsAndConditionsEntity? termsAndConditionsEntity,
  ) {
    switch (index) {
      case 0:
        context.goNamed(
          AppRoutes.support,
          extra: {
            'isElite': '${context.read<EliteCubit>().state}',
          },
        );
        break;
      case 1:
        BottomSheetUtils.general(
          context: context,
          height: MediaQuery.of(context).size.height * 0.8,
          bgColor: clrBlack080,
          titleText: termsAndConditionsEntity?.title,
          titleTextColor: clrWhite,
          content: Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    termsAndConditionsEntity?.description ?? '',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      color: clrWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case 2:
        context.goNamed(AppRoutes.aboutUs,
            extra: {'bloc': context.read<ProfileBloc>()});
        break;
      case 3:
        context.goNamed(AppRoutes.closeAccount,
            extra: {'bloc': context.read<ProfileBloc>()});
        break;
      default:
    }
  }

  String _kycStatus(AppLocalizations t, int? status) {
    switch (status) {
      case 0:
        return t.lblUnverified;
      case 1:
        return t.lblVerified;
      case 2:
        return t.lblOnProgress;
      case 3:
        return t.lblFailed;
      default:
        return t.lblUnverified;
    }
  }

  Color _textColor(int? status) {
    switch (status) {
      case 0:
        return clrRed;
      case 1:
        return clrGreen00A;
      case 2:
        return clrBackgroundBlack;
      case 3:
        return clrRed;
      default:
        return clrRed;
    }
  }

  Color _bgColor(int? status) {
    switch (status) {
      case 0:
        return clrRed;
      case 1:
        return clrGreen00B;
      case 2:
        return clrGreyE5e;
      case 3:
        return clrRed;
      default:
        return clrRed;
    }
  }
}
