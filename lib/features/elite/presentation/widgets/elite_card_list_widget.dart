import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class EliteCardListWidget extends StatelessWidget {
  final bool isElite;
  final int itemLength;
  final String? cardTitle;
  final String Function(int)? title;
  final String Function(int)? subTitle;
  final bool isUseDevider;
  final bool isShowSuccessIcon;
  final bool isShowCheckbox;
  final bool isSuccessTrx;
  const EliteCardListWidget({
    super.key,
    required this.isElite,
    this.itemLength = 0,
    this.cardTitle,
    this.title,
    this.subTitle,
    this.isUseDevider = true,
    this.isShowSuccessIcon = false,
    this.isShowCheckbox = true,
    this.isSuccessTrx = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              cardTitle ?? '',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isElite ? clrWhite : clrDarkBlue,
              ),
            ),
            const SizedBox(width: 8),
            if (isShowSuccessIcon) Image.asset(icCheckCircle, width: 16),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSuccessTrx
                  ? [
                      clrGreen00B.withOpacity(0.2),
                      clrGreen00B.withOpacity(0.1),
                    ]
                  : isElite
                      ? [
                          clrGreyE5e.withOpacity(0.12),
                          clrGreyE5e.withOpacity(0.12),
                        ]
                      : [
                          clrGreyE5e.withOpacity(0.25),
                          clrGreyE5e.withOpacity(0.25),
                        ],
            ),
          ),
          child: Column(
            children: List.generate(
              itemLength,
              (index) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title!(index),
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isElite
                              ? clrWhite.withOpacity(0.75)
                              : clrBackgroundBlack.withOpacity(0.75),
                        ),
                      ),
                      Text(
                        subTitle!(index),
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ],
                  ),
                  if (index != 2 && isSuccessTrx) const SizedBox(height: 16),
                  if (isUseDevider && index != (itemLength - 1))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: clrNeutralGrey999.withOpacity(0.16),
                      ),
                    ),
                  if (isSuccessTrx && index == 2)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: clrNeutralGrey999.withOpacity(0.16),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
