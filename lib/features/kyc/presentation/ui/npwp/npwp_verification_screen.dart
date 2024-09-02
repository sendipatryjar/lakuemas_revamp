import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../../cores/constants/kyc_status.dart';
import '../../../../../cores/constants/app_color.dart';
import '../../../../../cores/constants/img_assets.dart';
import '../../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../../cores/routes/app_routes.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../../cores/utils/dialog_utils.dart';
import '../../../../../cores/utils/text_utils.dart';
import '../../../../../cores/utils/widget_utils.dart';
import '../../../../../cores/widgets/camera_overlay/id_card/overlay_model.dart';
import '../../../../../cores/widgets/main_back_button.dart';
import '../../../../../cores/widgets/main_button.dart';
import '../../../../../cores/widgets/main_progress_bar.dart';
import '../../../../../cores/widgets/main_text_field.dart';
import '../../blocs/get_kyc_data/get_kyc_data_bloc.dart';
import '../../blocs/npwp/npwp_verification_bloc.dart';
import '../../cubits/npwp/npwp_verification_validation_cubit.dart';
import '../camera_overlay_screen.dart';

class NpwpVerificationScreen extends StatefulWidget {
  final double? aspectRatio;
  final XFile? xFile;
  final String? aditionalData;
  const NpwpVerificationScreen({
    super.key,
    required this.aspectRatio,
    required this.xFile,
    required this.aditionalData,
  });

  @override
  State<NpwpVerificationScreen> createState() => _NpwpVerificationScreenState();
}

class _NpwpVerificationScreenState extends State<NpwpVerificationScreen> {
  late TextEditingController noNpwpTec;

  void _confirm(BuildContext context, TextEditingController noNpwpTec) {
    final t = AppLocalizations.of(context)!;

    DialogUtils.confirm(
      context: context,
      barrierDismissible: true,
      firstDesc: t.lblPopUpConfirmTitle,
      secondDesc: t.lblPopUpConfirmDesc,
      btnText: t.lblConfirm,
      btnTextLater: t.lblLater,
      btnConfirm: () {
        context.read<NpwpVerificationBloc>().add(
              NpwpVerificationPressedEvent(
                noNpwpTec.text,
                widget.xFile!.path,
              ),
            );
        context.pop();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      btnLater: () {
        context.pop();
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    noNpwpTec = TextEditingController(text: widget.aditionalData);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<NpwpVerificationBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<NpwpVerificationValidationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<GetKycDataBloc>()..add(GetKycTriggered()),
        ),
      ],
      child: BlocListener<NpwpVerificationBloc, NpwpVerificationState>(
        listener: (context, state) {
          if (state is NpwpVerificationLoadingState) {
            EasyLoading.show();
          }
          if (state is NpwpVerificationSuccessState) {
            EasyLoading.dismiss();
            context.read<HelperDataCubit>().resetDataAfterTrx();
            Future.delayed(const Duration(seconds: 2)).then((value) {
              context.goNamed(AppRoutes.profile);
            });
            DialogUtils.success(
              context: context,
              barrierDismissible: true,
              firstDesc: t.lblConfirmDataSuccess,
              secondDesc: t.lblConfirmDataSuccessDesc,
              btnText: t.lblBack,
              btnOnPressed: () {
                context.goNamed(AppRoutes.profile);
              },
            );
          }
          if (state is NpwpVerificationFailureState) {
            EasyLoading.showError(
              '${state.message}',
              dismissOnTap: true,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblDataNPWP,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.goNamed(AppRoutes.accountVerification);
              },
            ),
          ),
          bottomNavigationBar: BlocBuilder<GetKycDataBloc, GetKycDataState>(
            builder: (context, state) {
              if (state is GetKycDataSuccessState) {
                final status = state.kycData?['npwp']?.status;

                if (status == KycStatus.verified ||
                    status == KycStatus.onProgress) {
                  return MainButton(
                    label: t.lblBackToBeranda,
                    onPressed: () => context.goNamed(AppRoutes.beranda),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      BlocBuilder<NpwpVerificationBloc, NpwpVerificationState>(
                    builder: (context, state) {
                      return MainButton(
                        label: t.lblSave,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          context
                              .read<NpwpVerificationValidationCubit>()
                              .validate(
                                t: t,
                                npwpNo: noNpwpTec.text,
                                file: widget.xFile,
                              );
                          final isValid = context
                              .read<NpwpVerificationValidationCubit>()
                              .isValid;
                          if (isValid) {
                            _confirm(context, noNpwpTec);
                          }
                        },
                      );
                    },
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          body: Column(
            children: [
              BlocBuilder<GetKycDataBloc, GetKycDataState>(
                builder: (context, state) {
                  int? status;
                  if (state is GetKycDataSuccessState) {
                    status = state.kycData?['npwp']?.status;
                  }
                  if (status == 1) {
                    return const SizedBox();
                  }
                  return Container(
                    padding: const EdgeInsets.all(20),
                    color: clrWhite,
                    child: MainProgressBar(
                      currentProgress: 1,
                      maxProgress: 2,
                      description: t.lblStepNPWPDesc,
                      descriptionPosition: DescriptionPosition.bottom,
                    ),
                  );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _fotoNPWP(
                          context: context,
                          noNpwpTec: noNpwpTec,
                        ),
                        const SizedBox(height: 16),
                        _nomorNPWP(context, noNpwpTec),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _nomorNPWP(BuildContext context, TextEditingController noNpwpTec) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<GetKycDataBloc, GetKycDataState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is GetKycDataSuccessState) {
          int? status = state.kycData?['npwp']?.status;
          // if ((state.kycData?['npwp']?.number ?? '').isNotEmpty) {
          //   noNpwpTec.text = state.kycData?['npwp']?.number ?? '';
          // }
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: clrGreyE5e.withOpacity(0.25),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: clrNeutralGrey999.withOpacity(0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.lblNumberNPWP,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<NpwpVerificationValidationCubit,
                    NpwpVerificationValidationState>(
                  builder: (context, state) {
                    return MainTextField(
                      hintText: t.lblFillNPWPNumber,
                      controller: noNpwpTec,
                      isDarkMode: false,
                      isRequired: true,
                      maxLines: 1,
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(15),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputType: TextInputType.number,
                      isError: state.isNpwpError ?? false,
                      errorText: state.npwpErrorMessages,
                      enabled: !(status == KycStatus.verified ||
                          status == KycStatus.onProgress),
                      onChange: (value) => context
                          .read<NpwpVerificationValidationCubit>()
                          .validateNpwpNo(
                            t: t,
                            value: value,
                          ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _fotoNPWP({
    required BuildContext context,
    TextEditingController? noNpwpTec,
  }) {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: clrGreyE5e.withOpacity(0.25),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: clrNeutralGrey999.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<GetKycDataBloc, GetKycDataState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              if (state is GetKycDataSuccessState) {
                final status = state.kycData?['npwp']?.status;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.lblPhotoNPWP,
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: clrDarkBlue,
                      ),
                    ),
                    status == KycStatus.unverified
                        ? Text(
                            t.lblNotUploaded,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: clrRed,
                            ),
                          )
                        : status == KycStatus.verified
                            ? Image.asset(
                                icCheckCircle,
                                width: 14,
                              )
                            : status == KycStatus.onProgress
                                ? Row(
                                    children: [
                                      Text(
                                        t.lblProcess,
                                        textScaler: TextScaler.linear(
                                            TextUtils.textScaleFactor(context)),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          color: clrBackgroundBlack,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Image.asset(icProcess),
                                    ],
                                  )
                                : const SizedBox(),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              thickness: 1,
              color: clrBackgroundBlack.withOpacity(0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BlocBuilder<GetKycDataBloc, GetKycDataState>(
                    buildWhen: (previous, current) => previous != current,
                    builder: (context, state) {
                      bool isUploaded = (widget.xFile?.path ?? '').isNotEmpty;
                      if (state is GetKycDataSuccessState) {
                        // final imageNpwp =
                        //     (state.kycData?['npwp']?.imageUrl ?? '').isNotEmpty;

                        // if ((imageNpwp)) {
                        //   isUploaded = imageNpwp;
                        // }
                        return GestureDetector(
                          onTap: () {
                            // if (state.kycData?['npwp']?.imageUrl != '' ||
                            //     (xFile!.path).isNotEmpty) {
                            //   _showPhotoNPWP(context,
                            //       state.kycData?['npwp']?.imageUrl ?? '');
                            // }
                            if (widget.xFile != null) {
                              OverlayFormat format = OverlayFormat.cardID1;
                              CardOverlay overlay =
                                  CardOverlay.byFormat(format);
                              WidgetUtils.showPhoto(
                                context: context,
                                xFile: widget.xFile,
                                imageUrl: null,
                                aspectRatio: overlay.ratio,
                              );
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: isUploaded
                                  ? Colors.transparent
                                  : clrBackgroundBlack.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: clrBackgroundBlack.withOpacity(0.08),
                              ),
                            ),
                            child: (widget.xFile?.path ?? '').isNotEmpty
                                ? AspectRatio(
                                    aspectRatio: widget.aspectRatio ?? 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isUploaded
                                            ? clrBackgroundBlack
                                                .withOpacity(0.75)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: clrBackgroundBlack
                                              .withOpacity(0.08),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          alignment: FractionalOffset.center,
                                          image: FileImage(
                                            File(widget.xFile!.path),
                                          ),
                                        ),
                                        // image: state.kycData?['npwp']?.status ==
                                        //             null ||
                                        //         state.kycData?['npwp']
                                        //                     ?.status ==
                                        //                 KycStatus.unverified &&
                                        //             (xFile?.path ?? '')
                                        //                 .isNotEmpty
                                        //     ? DecorationImage(
                                        //         fit: BoxFit.fitWidth,
                                        //         alignment:
                                        //             FractionalOffset.center,
                                        //         image: FileImage(
                                        //           File(xFile!.path),
                                        //         ),
                                        //       )
                                        //     : DecorationImage(
                                        //         fit: BoxFit.fitWidth,
                                        //         alignment:
                                        //             FractionalOffset.center,
                                        //         image: NetworkImage(state
                                        //                 .kycData?['npwp']
                                        //                 ?.imageUrl ??
                                        //             ''),
                                        //       ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(icEye),
                                          const SizedBox(width: 5),
                                          Text(
                                            t.lblViewPhoto,
                                            textScaler: TextScaler.linear(
                                                TextUtils.textScaleFactor(
                                                    context)),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: clrWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Image.asset(icChooseImage),
                                  ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          t.lblUploadNPWPDesc,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: clrBlack101,
                          ),
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<GetKycDataBloc, GetKycDataState>(
                          builder: (context, state) {
                            if (state is GetKycDataSuccessState) {
                              final status = state.kycData?['npwp']?.status;
                              return SizedBox(
                                width: double.infinity,
                                child: MainButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  label: t.lblTakePhoto,
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: clrBackgroundBlack,
                                  ),
                                  borderRadius: 15,
                                  bgColor: clrWhite,
                                  onPressed: (status == KycStatus.verified ||
                                          status == KycStatus.onProgress)
                                      ? null
                                      : () {
                                          context.goNamed(
                                              AppRoutes.cameraOverlay,
                                              pathParameters: {
                                                'cameraOverlayFor':
                                                    CameraOverlayFor.npwp,
                                              },
                                              extra: {
                                                'aditionalData':
                                                    noNpwpTec?.text,
                                              });
                                        },
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              BlocBuilder<NpwpVerificationValidationCubit,
                  NpwpVerificationValidationState>(
                builder: (context, state) {
                  if (state.isNpwpPhotoError == false &&
                      (state.npwpPhotoErrorMessages ?? '').isEmpty) {
                    return const SizedBox();
                  }
                  return Text(
                    state.npwpPhotoErrorMessages ?? '',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: clrRed,
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
