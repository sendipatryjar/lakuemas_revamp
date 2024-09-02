import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';

class EmptyBonusesWidget extends StatelessWidget {
  final bool isElite;
  const EmptyBonusesWidget({super.key, this.isElite = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        Image.asset(imgPeopleEmpty),
        const SizedBox(height: 32),
        Text(
          t.lblEmptyReward,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
