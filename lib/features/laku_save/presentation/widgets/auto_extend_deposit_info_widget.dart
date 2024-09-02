import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class AutoExtendDepositInfoWidget extends StatelessWidget {
  final bool isElite;
  const AutoExtendDepositInfoWidget({super.key, this.isElite = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            clrBlue006.withOpacity(0.16),
            clrBlue006.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1.5,
          color: clrBlue006.withOpacity(0.10),
        ),
      ),
      child: Row(
        children: [
          Image.asset(icInfo),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.lblExtendDepoInfo,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
