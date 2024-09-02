import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';

class EliteUnsubscribeSuccessScreen extends StatelessWidget {
  const EliteUnsubscribeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: clrBlack080,
      appBar: AppBar(
        backgroundColor: clrBackgroundBlack,
        centerTitle: true,
        elevation: 0,
        title: Text(
          t.lblUnsubscribe,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.beranda);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MainButton(
          label: t.lblBackToMainScreen,
          onPressed: () {
            context.goNamed(AppRoutes.beranda);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 224,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imgPeopleSeeU), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              t.lblSeeU,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: clrWhite),
            ),
            const SizedBox(height: 8),
            Text(
              t.lblSeeUDesc,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: clrWhite,
                height: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
