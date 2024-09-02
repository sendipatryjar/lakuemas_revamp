import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../../cores/constants/app_color.dart';
import '../../../../../cores/constants/img_assets.dart';
import '../../../../../cores/constants/kyc_status.dart';
import '../../../../../cores/constants/pin_type.dart';
import '../../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../../cores/routes/app_routes.dart';
import '../../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../../cores/utils/text_utils.dart';
import '../../../../../cores/utils/widget_utils.dart';
import '../../../../../cores/widgets/main_back_button.dart';
import '../../../../../cores/widgets/main_banner.dart';
import '../../../../../cores/widgets/main_button.dart';
import '../../blocs/get_kyc_data/get_kyc_data_bloc.dart';
import '../../blocs/kyc_ktp/kyc_ktp_bloc.dart';
import '../../widgets/field_container_widget.dart';

class PhotoSelfieVerificationResultScreen extends StatelessWidget {
  final double aspectRatio;
  final XFile? xFile;
  const PhotoSelfieVerificationResultScreen({
    super.key,
    required this.aspectRatio,
    required this.xFile,
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
      ],
      child: _Content(
        t: t,
        aspectRatio: aspectRatio,
        xFile: xFile,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  final double aspectRatio;
  final XFile? xFile;
  const _Content({
    Key? key,
    required this.t,
    required this.aspectRatio,
    required this.xFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblVerification,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        child: BlocBuilder<GetKycDataBloc, GetKycDataState>(
          builder: (context, state) {
            int? status;
            if (state is GetKycDataSuccessState) {
              status = state.kycData?['selfie']?.status;
              imageUrl = state.kycData?['selfie']?.imageUrl;
            }
            if (status == KycStatus.onProgress ||
                status == KycStatus.verified) {
              return MainButton(
                label: t.lblBackToBeranda,
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
                    'nextScreenPin': AppRoutes.accountVerificationSelfieGuide,
                    'eliteCubit': context.read<EliteCubit>(),
                  });
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<GetKycDataBloc, GetKycDataState>(
            builder: (context, state) {
              int? status;
              String? reason;
              if (state is GetKycDataSuccessState) {
                status = state.kycData?['selfie']?.status;
                imageUrl = state.kycData?['selfie']?.imageUrl;
                reason = state.kycData?['selfie']?.reason;
              }
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
                                'Maaf, proses verifikasimu gagal. Silahkan ajukan ulang',
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
              return const SizedBox();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<GetKycDataBloc, GetKycDataState>(
                    builder: (context, state) {
                      int? status;
                      if (state is GetKycDataSuccessState) {
                        status = state.kycData?['selfie']?.status;
                      }
                      return FieldContainerWidget(
                        title: 'Foto Selfie',
                        status: status,
                        content: InkWell(
                          onTap: () {
                            WidgetUtils.showPhoto(
                              context: context,
                              xFile: xFile,
                              imageUrl: imageUrl,
                              // aspectRatio: aspectRatio,
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: aspectRatio,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: xFile != null
                                    ? DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        alignment: FractionalOffset.center,
                                        image: FileImage(
                                          File(xFile!.path),
                                        ),
                                      )
                                    : null,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: clrBackgroundBlack.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(icEye),
                                    const SizedBox(width: 5),
                                    Text(
                                      t.lblViewPhoto,
                                      textScaler: TextScaler.linear(
                                          TextUtils.textScaleFactor(context)),
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
