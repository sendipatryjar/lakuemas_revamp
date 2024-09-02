import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_banner.dart';

class ProfileBannerWidget extends StatelessWidget {
  const ProfileBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MainBanner(
      content: Row(
        children: [
          Image.asset(icWarningRed),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              t.lblUnverifiedDesc,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: clrBackgroundBlack,
              ),
            ),
          )
        ],
      ),
    );
  }
}
