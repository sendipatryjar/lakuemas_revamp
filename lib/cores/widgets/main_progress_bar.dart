import 'package:flutter/material.dart';

import '../constants/app_color.dart';
import '../utils/text_utils.dart';

enum DescriptionPosition { right, bottom }

class MainProgressBar extends StatelessWidget {
  final int currentProgress;
  final int maxProgress;
  final String? description;
  final DescriptionPosition descriptionPosition;
  final Color? bgColor;
  final Color? valueColor;
  const MainProgressBar({
    super.key,
    this.currentProgress = 0,
    this.maxProgress = 3,
    this.description,
    this.descriptionPosition = DescriptionPosition.right,
    this.bgColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 10,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: LinearProgressIndicator(
                    value: currentProgress / maxProgress,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(valueColor ?? clrYellow),
                    backgroundColor:
                        bgColor ?? clrBackgroundBlack.withOpacity(0.1),
                  ),
                ),
              ),
            ),
            if (descriptionPosition == DescriptionPosition.right &&
                (description ?? '').isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  description ?? '',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: clrBackgroundBlack.withOpacity(0.75),
                  ),
                ),
              ),
          ],
        ),
        if (descriptionPosition == DescriptionPosition.bottom &&
            (description ?? '').isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              description ?? '',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: clrBackgroundBlack.withOpacity(0.75),
              ),
            ),
          )
      ],
    );
  }
}
