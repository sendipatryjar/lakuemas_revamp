import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class EmptyTrxAccountBalanceWidget extends StatelessWidget {
  final bool isElite;
  const EmptyTrxAccountBalanceWidget({super.key, required this.isElite});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        Image.asset(imgPeopleEmpty),
        const SizedBox(height: 25),
        Text(
          t.lblEmptyCashWithdrawal,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
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
