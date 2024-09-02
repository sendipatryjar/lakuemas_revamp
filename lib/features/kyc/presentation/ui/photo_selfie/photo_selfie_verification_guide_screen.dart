import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../cores/constants/app_color.dart';
import '../../../../../cores/constants/img_assets.dart';
import '../../../../../cores/routes/app_routes.dart';
import '../../../../../cores/utils/dialog_utils.dart';
import '../../../../../cores/utils/text_utils.dart';
import '../../../../../cores/widgets/main_back_button.dart';
import '../../../../../cores/widgets/main_button.dart';

class PhotoSelfieVerificationGuideScreen extends StatelessWidget {
  const PhotoSelfieVerificationGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
            context.goNamed(AppRoutes.accountVerification);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: _mainButton(t, context),
      ),
      body: Column(
        children: [
          // Container(
          //   padding: const EdgeInsets.all(20.0),
          //   decoration: BoxDecoration(
          //     color: clrWhite,
          //   ),
          //   child: MainProgressBar(
          //     currentProgress: 1,
          //     maxProgress: 2,
          //     description: t.lblStepFromTo('1', '2', t.lblGuide),
          //     descriptionPosition: DescriptionPosition.bottom,
          //   ),
          // ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 4,
              ),
              decoration: BoxDecoration(
                color: clrGreyE5e.withOpacity(0.25),
                border: Border.all(color: clrNeutralGrey999.withOpacity(0.16)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.lblPhotoGuide,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: clrDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                      3,
                      (index) => Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: _guideDescWidget(context, t, index),
                          )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _guideDescWidget(BuildContext context, AppLocalizations t, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 8,
            color: clrBackgroundBlack,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            _guideDescStr(t, index),
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: clrBackgroundBlack,
            ),
          ),
        )
      ],
    );
  }

  String _guideDescStr(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblSelfieGuideDescOne;
      case 1:
        return t.lblSelfieGuideDescTwo;
      case 2:
        return t.lblSelfieGuideDescThree;
      default:
        return '';
    }
  }

  MainButton _mainButton(AppLocalizations t, BuildContext context) {
    return MainButton(
      label: t.lblTakePhoto,
      onPressed: () {
        Permission.camera.request().then((status) {
          if (status.isGranted) {
            context.goNamed(
              // AppRoutes.cameraOverlay,
              // pathParameters: {'cameraOverlayFor': CameraOverlayFor.selfie},
              AppRoutes.accountLivenessSelfie,
            );
          }
          if (status.isPermanentlyDenied) {
            DialogUtils.universal(
              context: context,
              barrierDismissible: true,
              icon: Image.asset(icWarningYellow),
              firstDesc: 'Perizinan Kamera',
              secondDesc:
                  'Mohon untuk aktifkan perizinan kamera pada menu Settings di ponsel anda',
              btnText: 'Buka Settings',
              btnConfirm: () => openAppSettings(),
            );
          }
        });
      },
    );
  }
}
