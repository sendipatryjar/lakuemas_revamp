import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/constants/kyc_status.dart';
import '../../../../cores/constants/pin_type.dart';
import '../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/utils/image_utils.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/camera_overlay/id_card/overlay_model.dart';
import '../../../../cores/widgets/card_list_widget.dart';
import '../../../../cores/widgets/label_status_widget.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../../../../cores/widgets/main_banner.dart';
import '../../../../cores/widgets/main_progress_bar.dart';
import '../../domain/entities/object_kyc_entity.dart';
import '../blocs/get_kyc_data/get_kyc_data_bloc.dart';

class AccountVerificationScreen extends StatelessWidget {
  const AccountVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<GetKycDataBloc>()..add(GetKycTriggered()),
      child: _Content(t: t),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.t,
  }) : super(key: key);

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblAccountVerification,
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
          child: Column(
            children: [
              BlocBuilder<GetKycDataBloc, GetKycDataState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  int currProgress = 0;
                  int maxProgress = 3;
                  if (state is GetKycDataSuccessState) {
                    maxProgress = state.kycData?.values.length ?? maxProgress;
                    for (var eVal in (state.kycData?.values.toList() ??
                        <ObjectKycEntity?>[])) {
                      if (eVal?.status == 1) {
                        currProgress = currProgress + 1;
                      }
                    }
                  }
                  return MainProgressBar(
                    currentProgress: currProgress,
                    maxProgress: maxProgress,
                    description: '$currProgress/$maxProgress',
                    descriptionPosition: DescriptionPosition.right,
                  );
                },
              ),
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: clrGreyE5e.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: clrA8A8A8.withOpacity(0.24)),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      imgPeopleOfficeHours,
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        t.lblVerificationDurationDesc,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: clrBackgroundBlack.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<GetKycDataBloc, GetKycDataState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is GetKycDataSuccessState) {
                    Map<String, ObjectKycEntity?>? sortedKycData = {};
                    sortedKycData.addAll({
                      'ktp': state.kycData?['ktp'],
                      'selfie': state.kycData?['selfie'],
                      'npwp': state.kycData?['npwp'],
                      'account_number': state.kycData?['account_number'],
                    });
                    return CardListWidget(
                      itemLength: sortedKycData.keys.length,
                      title: (index) => _itemTitle(t, index, sortedKycData),
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: clrBackgroundBlack,
                      ),
                      rightWidget: (index) =>
                          _itemRightWidget(t, index, sortedKycData),
                      isUseDevider: true,
                      isUseRightArrow: false,
                      onTap: (index) =>
                          _itemOnTap(context, index, sortedKycData),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
              MainBanner(
                bgColor: clrYellow.withOpacity(0.16),
                content: Row(
                  children: [
                    Image.asset(icWarningOrange),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'Data KTP dan Foto Selfie wajib dilengkapi demi kemudahan menikmati fitur-fitur Laku Emas',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: clrBackgroundBlack,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _itemTitle(
      AppLocalizations t, int index, Map<String, ObjectKycEntity?>? kycData) {
    final objectKyc = kycData?.keys.toList()[index].toLowerCase();
    switch (objectKyc) {
      case 'ktp':
        return t.lblKtpData;
      case 'selfie':
        return t.lblSelfiePhoto;
      case 'npwp':
        return t.lblNpwpData;
      case 'account_number':
        return t.lblBankAccountData;
      default:
        return '-';
    }
  }

  void _itemOnTap(
      BuildContext context, int index, Map<String, ObjectKycEntity?>? kycData) {
    final kycName = kycData?.keys.toList()[index].toLowerCase();
    var data = kycData?[kycName];
    switch (kycName) {
      case 'ktp':
        if (data?.status == KycStatus.onProgress ||
            data?.status == KycStatus.verified ||
            data?.status == KycStatus.rejected) {
          EasyLoading.show();
          MainImageUtils.imageUrlToFile(url: data?.imageUrl ?? '')
              .then((value) {
            EasyLoading.dismiss();
            var xFile = XFile(value.path);
            OverlayFormat format = OverlayFormat.cardID1;
            CardOverlay overlay = CardOverlay.byFormat(format);
            context.goNamed(AppRoutes.accountVerificationKtpResultAlreadyKyc,
                extra: {
                  'xFile': xFile,
                  'aspectRatio': overlay.ratio,
                  'nik': data?.number,
                  'name': data?.name,
                  'pob': data?.pob,
                  'dob': data?.dob,
                  'backScreen': AppRoutes.accountVerification,
                  'eliteCubit': context.read<EliteCubit>(),
                });
          }).onError((error, stackTrace) {
            EasyLoading.dismiss();
            OverlayFormat format = OverlayFormat.cardID1;
            CardOverlay overlay = CardOverlay.byFormat(format);
            context.goNamed(AppRoutes.accountVerificationKtpResultAlreadyKyc,
                extra: {
                  'xFile': null,
                  'aspectRatio': overlay.ratio,
                  'nik': data?.number,
                  'name': data?.name,
                  'pob': data?.pob,
                  'dob': data?.dob,
                  'backScreen': AppRoutes.accountVerification,
                  'eliteCubit': context.read<EliteCubit>(),
                });
          });
          return;
        }
        context.goNamed(AppRoutes.pin, extra: {
          'pinType': '${PinType.validate}',
          'backScreenPin': AppRoutes.accountVerification,
          'nextScreenPin': AppRoutes.accountVerificationKtpGuide,
          'eliteCubit': context.read<EliteCubit>(),
        });
        break;
      case 'selfie':
        if (data?.status == KycStatus.onProgress ||
            data?.status == KycStatus.verified ||
            data?.status == KycStatus.rejected) {
          EasyLoading.show();
          MainImageUtils.imageUrlToFile(url: data?.imageUrl ?? '')
              .then((value) {
            EasyLoading.dismiss();
            var xFile = XFile(value.path);
            OverlayFormat format = OverlayFormat.cardID1;
            CardOverlay overlay = CardOverlay.byFormat(format);
            context.goNamed(
              AppRoutes.accountVerificationSelfieResultAlreadyKyc,
              extra: {
                'xFile': xFile,
                'aspectRatio': overlay.ratio,
                'eliteCubit': context.read<EliteCubit>(),
              },
            );
          }).onError((error, stackTrace) {
            EasyLoading.dismiss();
            OverlayFormat format = OverlayFormat.cardID1;
            CardOverlay overlay = CardOverlay.byFormat(format);
            context.goNamed(
              AppRoutes.accountVerificationSelfieResultAlreadyKyc,
              extra: {
                'xFile': null,
                'aspectRatio': overlay.ratio,
                'eliteCubit': context.read<EliteCubit>(),
              },
            );
          });

          return;
        }
        context.goNamed(AppRoutes.pin, extra: {
          'pinType': '${PinType.validate}',
          'backScreenPin': AppRoutes.accountVerification,
          'nextScreenPin': AppRoutes.accountVerificationSelfieGuide,
          'eliteCubit': context.read<EliteCubit>(),
        });
        break;
      case 'npwp':
        if (data?.status == KycStatus.onProgress ||
            data?.status == KycStatus.verified ||
            data?.status == KycStatus.rejected) {
          EasyLoading.show();
          MainImageUtils.imageUrlToFile(url: data?.imageUrl ?? '')
              .then((value) {
            EasyLoading.dismiss();
            var xFile = XFile(value.path);
            OverlayFormat format = OverlayFormat.cardID1;
            CardOverlay overlay = CardOverlay.byFormat(format);
            context.goNamed(
              AppRoutes.accountVerificationNpwpResultAlreadyKyc,
              extra: {
                'xFile': xFile,
                'aspectRatio': overlay.ratio,
                'nik': data?.number,
                'backScreen': AppRoutes.accountVerification,
                'eliteCubit': context.read<EliteCubit>(),
              },
            );
          }).onError((error, stackTrace) {
            EasyLoading.dismiss();
            OverlayFormat format = OverlayFormat.cardID1;
            CardOverlay overlay = CardOverlay.byFormat(format);
            context.goNamed(
              AppRoutes.accountVerificationNpwpResultAlreadyKyc,
              extra: {
                'xFile': null,
                'aspectRatio': overlay.ratio,
                'nik': data?.number,
                'backScreen': AppRoutes.accountVerification,
                'eliteCubit': context.read<EliteCubit>(),
              },
            );
          });

          return;
        }
        context.goNamed(AppRoutes.pin, extra: {
          'pinType': '${PinType.validate}',
          'backScreenPin': AppRoutes.accountVerification,
          'nextScreenPin': AppRoutes.accountVerificationNpwp,
          'eliteCubit': context.read<EliteCubit>(),
        });
        break;
      case 'account_number':
        if (data?.status == KycStatus.onProgress ||
            data?.status == KycStatus.verified ||
            data?.status == KycStatus.rejected) {
          context.goNamed(
            AppRoutes.accountVerificationBankResultAlreadyKyc,
            pathParameters: {
              'initialBankId':
                  (kycData?['account_number']?.bankId ?? 0).toString(),
            },
            extra: {
              'eliteCubit': context.read<EliteCubit>(),
              'isResult': true,
            },
          );
          return;
        }
        context.goNamed(AppRoutes.pin, extra: {
          'pinType': '${PinType.validate}',
          'backScreenPin': AppRoutes.accountVerification,
          'nextScreenPin': AppRoutes.accountVerificationBank,
          'eliteCubit': context.read<EliteCubit>(),
        });
        break;
      default:
    }
  }

  Widget _itemRightWidget(
      AppLocalizations t, int index, Map<String, ObjectKycEntity?>? kycData) {
    final objectKyc = kycData?.keys.toList()[index].toLowerCase();
    return LabelStatusWidget(
      text: _kycStatus(t, kycData?[objectKyc]?.status),
      textColor: _textColor(kycData?[objectKyc]?.status),
      bgColor: _bgColor(kycData?[objectKyc]?.status),
      borderColor: _bgColor(kycData?[objectKyc]?.status),
    );
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
