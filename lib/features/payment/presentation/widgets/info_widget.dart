import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_banner.dart';

class InfoWidget extends StatelessWidget {
  final String text;
  final bool isElite;
  const InfoWidget({super.key, required this.text, this.isElite = false});

  @override
  Widget build(BuildContext context) {
    return MainBanner(
      bgColor: clrYellow.withOpacity(0.16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      content: Row(
        children: [
          Image.asset(icWarningOrange),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              text,
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
