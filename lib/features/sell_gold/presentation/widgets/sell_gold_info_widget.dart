import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_banner.dart';

class SellGoldInfoWidget extends StatelessWidget {
  final bool isElite;
  const SellGoldInfoWidget({super.key, this.isElite = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MainBanner(
      bgColor: clrYellow.withOpacity(0.16),
      content: Row(
        children: [
          Image.asset(icWarningOrange),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              t.lblSellGoldTimeWarning,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
          )
        ],
      ),
    );
  }
}
