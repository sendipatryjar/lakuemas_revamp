import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../../cores/constants/app_color.dart';
import '../../../../../cores/constants/img_assets.dart';
import '../../../../../cores/routes/app_routes.dart';
import '../../../../../cores/utils/text_utils.dart';
import '../../../../../cores/widgets/main_back_button.dart';
import '../../../../../cores/widgets/main_button.dart';
import '../../../../../cores/widgets/main_progress_bar.dart';
import '../camera_overlay_screen.dart';

class KtpVerificationGuideScreen extends StatelessWidget {
  const KtpVerificationGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblKtpPhoto,
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
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: clrWhite,
            ),
            child: MainProgressBar(
              currentProgress: 1,
              maxProgress: 2,
              description: t.lblStepFromTo('1', '2', t.lblGuide),
              descriptionPosition: DescriptionPosition.bottom,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
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
                  border:
                      Border.all(color: clrNeutralGrey999.withOpacity(0.16)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.lblPhotoGuide,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: clrDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _imgGuide(
                              context,
                              imgKtp: imgKtpGuideRight,
                              textIcon: icCheckCircle,
                              text: t.lblRight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _imgGuide(
                              context,
                              imgKtp: imgKtpGuideWrong,
                              textIcon: icCrossCircle,
                              text: t.lblWrong,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 40),
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
        return t.lblPhotoGuideDescOne;
      case 1:
        return t.lblPhotoGuideDescTwo;
      case 2:
        return t.lblPhotoGuideDescThree;
      default:
        return '';
    }
  }

  Column _imgGuide(BuildContext context,
      {required String imgKtp,
      required String textIcon,
      required String text}) {
    return Column(
      children: [
        Image.asset(imgKtp),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              textIcon,
              height: 16,
              width: 16,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: clrBackgroundBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }

  MainButton _mainButton(AppLocalizations t, BuildContext context) {
    return MainButton(
      label: t.lblTakePhoto,
      onPressed: () {
        context.goNamed(
          AppRoutes.cameraOverlay,
          pathParameters: {'cameraOverlayFor': CameraOverlayFor.ktp},
        );
      },
    );
  }
}
