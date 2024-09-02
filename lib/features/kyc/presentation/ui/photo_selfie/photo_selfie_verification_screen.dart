import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/constants/app_color.dart';
import '../../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../../cores/routes/app_routes.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../../cores/utils/app_utils.dart';
import '../../../../../cores/utils/dialog_utils.dart';
import '../../../../../cores/utils/text_utils.dart';
import '../../../../../cores/widgets/main_back_button.dart';
import '../../../../../cores/widgets/main_button.dart';
import '../../../../../cores/widgets/main_progress_bar.dart';
import '../../blocs/get_kyc_data/get_kyc_data_bloc.dart';
import '../../blocs/kyc_selfie/kyc_selfie_bloc.dart';

class PhotoSelfieVerificationScreen extends StatelessWidget {
  final XFile xFile;
  final String? backScreen;
  const PhotoSelfieVerificationScreen({
    super.key,
    required this.xFile,
    this.backScreen,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<KycSelfieBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<GetKycDataBloc>()..add(GetKycTriggered()),
        ),
      ],
      child: BlocListener<KycSelfieBloc, KycSelfieState>(
        listener: (context, state) {
          if (state is KycSelfieLoadingState) {
            EasyLoading.show();
          }
          if (state is KycSelfieSuccessState) {
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
          if (state is KycSelfieFailureState) {
            appPrint('//${state.code}: ${state.message}');
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(t: t, xFile: xFile, backScreen: backScreen),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final XFile xFile;
  final String? backScreen;
  const _Content({
    Key? key,
    required this.t,
    required this.xFile,
    this.backScreen,
  }) : super(key: key);

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblSelfiePhoto,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.pop();
            // context.goNamed(backScreen ?? AppRoutes.accountVerificationSelfie);
          },
        ),
      ),
      bottomNavigationBar:
          // backScreen != null
          //     ? null
          //     :
          Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: MainButton(
                label: t.lblRetakePhoto,
                bgColor: clrGreyF2f.withOpacity(0.5),
                onPressed: () {
                  context.goNamed(
                    // AppRoutes.cameraOverlay,
                    // pathParameters: {'cameraOverlayFor': CameraOverlayFor.selfie},
                    AppRoutes.accountLivenessSelfie,
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: MainButton(
                label: t.lblSave,
                onPressed: () {
                  _confirm(context);
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
              if (state is GetKycDataSuccessState) {
                status = state.kycData?['selfie']?.status;
              }
              if (status == 1) {
                return const SizedBox();
              }
              return Container(
                padding: const EdgeInsets.all(20),
                color: clrWhite,
                child: MainProgressBar(
                  currentProgress: 2,
                  maxProgress: 2,
                  description: t.lblStepFromTo('2', '2', t.lblCheckPhoto),
                  descriptionPosition: DescriptionPosition.bottom,
                ),
              );
            },
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        alignment: FractionalOffset.center,
                        image: FileImage(
                          File(xFile.path),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirm(BuildContext context) {
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
        context.read<KycSelfieBloc>().add(KycSelfiePressed(
              selfiePhotoBytes: await xFile.readAsBytes(),
            ));
      },
      btnLater: () {
        context.pop();
      },
    );
  }
}
