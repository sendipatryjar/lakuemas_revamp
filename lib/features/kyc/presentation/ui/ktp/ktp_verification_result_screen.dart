import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../cores/constants/app_color.dart';
import '../../../../../cores/constants/img_assets.dart';
import '../../../../../cores/constants/kyc_status.dart';
import '../../../../../cores/constants/pin_type.dart';
import '../../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../../cores/routes/app_routes.dart';
import '../../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../../cores/utils/app_utils.dart';
import '../../../../../cores/utils/dialog_utils.dart';
import '../../../../../cores/utils/text_utils.dart';
import '../../../../../cores/utils/widget_utils.dart';
import '../../../../../cores/widgets/main_back_button.dart';
import '../../../../../cores/widgets/main_banner.dart';
import '../../../../../cores/widgets/main_button.dart';
import '../../../../../cores/widgets/main_date_picker.dart';
import '../../../../../cores/widgets/main_progress_bar.dart';
import '../../../../../cores/widgets/main_text_field.dart';
import '../../blocs/get_kyc_data/get_kyc_data_bloc.dart';
import '../../blocs/kyc_ktp/kyc_ktp_bloc.dart';
import '../../cubits/ktp/ktp_validation_cubit.dart';
import '../../widgets/field_container_widget.dart';
import '../camera_overlay_screen.dart';

void _confirm(
  BuildContext context,
  TextEditingController? nikTec,
  TextEditingController? nameTec,
  TextEditingController? pobTec,
  String? dob,
  XFile ktpPhoto,
) {
  final t = AppLocalizations.of(context)!;
  DialogUtils.confirm(
    context: context,
    barrierDismissible: true,
    firstDesc: t.lblPopUpConfirmTitle,
    secondDesc: t.lblPopUpConfirmDesc,
    btnText: t.lblConfirm,
    btnTextLater: t.lblLater,
    btnConfirm: () async {
      context.pop();
      context.read<KycKtpBloc>().add(KycKtpPressed(
            t: t,
            nik: nikTec?.text,
            name: nameTec?.text,
            pob: pobTec?.text,
            dob: dob,
            ktpPhoto: await ktpPhoto.readAsBytes(),
          ));
    },
    btnLater: () {
      context.pop();
    },
  );
}

class KtpVerificationResultScreen extends StatelessWidget {
  final double aspectRatio;
  final XFile? xFile;
  final String? nik;
  final String? name;
  final String? pob;
  final String? dob;
  final String? backScreen;
  const KtpVerificationResultScreen({
    super.key,
    required this.aspectRatio,
    required this.xFile,
    this.nik,
    this.name,
    this.pob,
    this.dob,
    this.backScreen,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<KycKtpBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<GetKycDataBloc>()..add(GetKycTriggered()),
        ),
        BlocProvider(
          create: (context) => sl<KtpValidationCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<KycKtpBloc, KycKtpState>(
            listener: (context, state) {
              if (state is KycKtpLoadingState) {
                EasyLoading.show();
              }
              if (state is KycKtpSuccessState) {
                EasyLoading.dismiss();
                context.read<HelperDataCubit>().resetDataAfterTrx();
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  context.goNamed(AppRoutes.profile);
                });
                DialogUtils.success(
                  context: context,
                  barrierDismissible: false,
                  firstDesc: t.lblDataSavedSuccess,
                  secondDesc: t.lblVerificationDurationDesc,
                  btnText: t.lblBack,
                  btnOnPressed: () {},
                );
              }
              if (state is KycKtpFailureValidateState) {
                EasyLoading.dismiss();
              }
              if (state is KycKtpFailureState) {
                appPrint('${state.code}: ${state.message}');
                EasyLoading.showError(
                  errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                  dismissOnTap: true,
                );
              }
            },
          ),
        ],
        child: _Content(
          t: t,
          aspectRatio: aspectRatio,
          xFile: xFile,
          nik: nik,
          name: name,
          pob: pob,
          dob: dob,
          backScreen: backScreen,
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  final AppLocalizations t;
  final double aspectRatio;
  final XFile? xFile;
  final String? nik;
  final String? name;
  final String? pob;
  final String? dob;
  final String? backScreen;
  const _Content({
    Key? key,
    required this.t,
    required this.aspectRatio,
    required this.xFile,
    this.nik,
    this.name,
    this.pob,
    this.dob,
    this.backScreen,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late TextEditingController nikTec;
  late TextEditingController nameTec;
  late TextEditingController pobTec;

  String? imageUrl;
  String? dobHelper;

  @override
  void initState() {
    super.initState();

    nikTec = TextEditingController(text: widget.nik);
    nameTec = TextEditingController(text: widget.name);
    pobTec = TextEditingController(text: widget.pob);
    dobHelper = widget.dob;
    context.read<KtpValidationCubit>().changeTtl(dobHelper);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          widget.t.lblKtpPhoto,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(
                widget.backScreen ?? AppRoutes.accountVerificationKtpGuide);
          },
        ),
      ),
      bottomNavigationBar: widget.backScreen != null
          ? Container(
              margin: const EdgeInsets.all(20),
              child: BlocBuilder<GetKycDataBloc, GetKycDataState>(
                builder: (context, state) {
                  int? status;
                  if (state is GetKycDataSuccessState) {
                    status = state.kycData?['ktp']?.status;
                    imageUrl = state.kycData?['ktp']?.imageUrl;
                  }
                  if (status == KycStatus.onProgress ||
                      status == KycStatus.verified) {
                    return MainButton(
                      label: widget.t.lblBackToBeranda,
                      onPressed: () => context.goNamed(AppRoutes.beranda),
                    );
                  }
                  if (status == KycStatus.rejected) {
                    return MainButton(
                      label: 'Ulangi Proses Verifikasi',
                      onPressed: () {
                        context.goNamed(AppRoutes.pin, extra: {
                          'pinType': '${PinType.validate}',
                          'backScreenPin': AppRoutes.accountVerification,
                          'nextScreenPin':
                              AppRoutes.accountVerificationKtpGuide,
                          'eliteCubit': context.read<EliteCubit>(),
                        });
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: MainButton(
                      label: widget.t.lblRetakePhoto,
                      bgColor: clrGreyF2f.withOpacity(0.5),
                      onPressed: () {
                        context.goNamed(
                          AppRoutes.cameraOverlay,
                          pathParameters: {
                            'cameraOverlayFor': CameraOverlayFor.ktp
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: MainButton(
                      label: widget.t.lblSave,
                      onPressed: () {
                        context.read<KtpValidationCubit>().validate(
                              t: widget.t,
                              ktpNumber: nikTec.text,
                              ktpPhoto: widget.xFile,
                              name: nameTec.text,
                              pob: pobTec.text,
                              dob: dobHelper,
                            );
                        final isValidated =
                            context.read<KtpValidationCubit>().isValidated();
                        if (isValidated && widget.xFile != null) {
                          _confirm(context, nikTec, nameTec, pobTec, dobHelper,
                              widget.xFile!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
      body: Column(
        children: [
          BlocBuilder<GetKycDataBloc, GetKycDataState>(
            builder: (context, state) {
              int? status;
              String? reason;
              if (state is GetKycDataSuccessState) {
                status = state.kycData?['ktp']?.status;
                imageUrl = state.kycData?['ktp']?.imageUrl;
                reason = state.kycData?['ktp']?.reason;
              }
              if (widget.backScreen != null) {
                if (status == KycStatus.verified) {
                  return const SizedBox();
                }
                if (status == KycStatus.rejected) {
                  return Container(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 20,
                    ),
                    child: MainBanner(
                      content: Row(
                        children: [
                          Image.asset(
                            icWarningRed,
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              reason ??
                                  'Maaf, proses verifikasimu gagal, silahkan ajukan ulang',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
              return Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: clrWhite,
                ),
                child: MainProgressBar(
                  currentProgress: 2,
                  maxProgress: 2,
                  description:
                      widget.t.lblStepFromTo('2', '2', widget.t.lblCheckPhoto),
                  descriptionPosition: DescriptionPosition.bottom,
                ),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  BlocBuilder<GetKycDataBloc, GetKycDataState>(
                    builder: (context, state) {
                      int? status;
                      if (state is GetKycDataSuccessState) {
                        status = state.kycData?['ktp']?.status;
                      }
                      return FieldContainerWidget(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        title: "Informasi KTP",
                        status: widget.backScreen != null ? status : null,
                        content: Column(
                          children: [
                            KycFieldTitleWidget(
                              // status: backScreen != null ? status : null,
                              content: InkWell(
                                onTap: () {
                                  WidgetUtils.showPhoto(
                                    context: context,
                                    xFile: widget.xFile,
                                    imageUrl: imageUrl,
                                    aspectRatio: widget.aspectRatio,
                                  );
                                },
                                child: AspectRatio(
                                  aspectRatio: widget.aspectRatio,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: widget.xFile != null
                                          ? DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              alignment:
                                                  FractionalOffset.center,
                                              image: FileImage(
                                                File(widget.xFile!.path),
                                              ),
                                            )
                                          : null,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            clrBackgroundBlack.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(icEye),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.t.lblViewPhoto,
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
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Divider(
                                thickness: 1,
                                color: clrBackgroundBlack.withOpacity(0.08),
                              ),
                            ),
                            KycFieldTitleWidget(
                              title: 'Nomor KTP',
                              // status: backScreen != null ? status : null,
                              content: BlocBuilder<KtpValidationCubit,
                                  KtpValidationState>(
                                builder: (context, state) {
                                  return MainTextField(
                                    controller: nikTec,
                                    hintText: "Tulis Nomor KTP kamu",
                                    titleColor:
                                        clrBackgroundBlack.withOpacity(0.75),
                                    isDarkMode: false,
                                    textInputFormatter: [
                                      LengthLimitingTextInputFormatter(16),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputType: TextInputType.number,
                                    isError: (widget.backScreen != null &&
                                            status == KycStatus.rejected)
                                        ? true
                                        : (state.isNikError == true),
                                    errorText: state.nikErrorMessages,
                                    enabled: widget.backScreen == null,
                                    onChange: (value) => context
                                        .read<KtpValidationCubit>()
                                        .validateKtpNumber(
                                          t: widget.t,
                                          ktpNumber: value,
                                        ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            KycFieldTitleWidget(
                              title: 'Nama',
                              // status: backScreen != null ? status : null,
                              content: BlocBuilder<KtpValidationCubit,
                                  KtpValidationState>(
                                builder: (context, state) {
                                  return MainTextField(
                                    controller: nameTec,
                                    hintText: "Nama lengkap sesuai KTP",
                                    titleColor:
                                        clrBackgroundBlack.withOpacity(0.75),
                                    isDarkMode: false,
                                    isError: (widget.backScreen != null &&
                                            status == KycStatus.rejected)
                                        ? true
                                        : (state.isNameError == true),
                                    errorText: state.nameErrorMessages,
                                    enabled: widget.backScreen == null,
                                    onChange: (value) => context
                                        .read<KtpValidationCubit>()
                                        .validateName(
                                          t: widget.t,
                                          name: value,
                                        ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            KycFieldTitleWidget(
                              title: widget.t.lblPlaceOfBirth,
                              // status: backScreen != null ? status : null,
                              content: BlocBuilder<KtpValidationCubit,
                                  KtpValidationState>(
                                builder: (context, state) {
                                  return MainTextField(
                                    controller: pobTec,
                                    hintText: "Tulis Tempat Lahir",
                                    titleColor:
                                        clrBackgroundBlack.withOpacity(0.75),
                                    isDarkMode: false,
                                    isError: (widget.backScreen != null &&
                                            status == KycStatus.rejected)
                                        ? true
                                        : (state.isPobError == true),
                                    errorText: state.pobErrorMessages,
                                    enabled: widget.backScreen == null,
                                    onChange: (value) => context
                                        .read<KtpValidationCubit>()
                                        .validatePob(
                                          t: widget.t,
                                          pob: value,
                                        ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            KycFieldTitleWidget(
                              title: widget.t.lblDateOfBirth,
                              // status: backScreen != null ? status : null,
                              content: BlocBuilder<KtpValidationCubit,
                                  KtpValidationState>(
                                builder: (context, state) {
                                  final dateTime = (dobHelper ?? "").isNotEmpty
                                      ? DateFormat('dd-MM-yyyy')
                                          .parse(dobHelper!)
                                      : null;
                                  final dateTimeFormated = dateTime != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(dateTime)
                                      : null;
                                  return MainDatePicker(
                                    titleColor:
                                        clrBackgroundBlack.withOpacity(0.75),
                                    hintText: (dateTimeFormated ?? '')
                                            .isNotEmpty
                                        ? dateTimeFormated
                                        : '${widget.t.lblSelect} ${widget.t.lblDateOfBirth}',
                                    initialDate: (state.ttl ?? "").isNotEmpty
                                        ? DateFormat('dd-MM-yyyy')
                                            .parse(state.ttl!)
                                        : null,
                                    onChanged: (value) {
                                      final strDate = value != null
                                          ? DateFormat('dd-MM-yyyy')
                                              .format(value)
                                          : null;
                                      context
                                          .read<KtpValidationCubit>()
                                          .validateDob(
                                            t: widget.t,
                                            dob: strDate,
                                          );
                                      dobHelper = strDate;
                                      context
                                          .read<KtpValidationCubit>()
                                          .changeTtl(dobHelper);
                                    },
                                    enabled: widget.backScreen == null,
                                    isError: (widget.backScreen != null &&
                                            status == KycStatus.rejected)
                                        ? true
                                        : (state.isDobError == true),
                                    errorText: state.dobErrorMessages,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
