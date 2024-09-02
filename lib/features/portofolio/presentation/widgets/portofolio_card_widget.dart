import 'package:flutter/material.dart';
import '../../../../cores/constants/app_color.dart';

import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_progress_bar.dart';

class PortofolioCardWidget extends StatelessWidget {
  final bool isElite;
  final String imgUrl;
  final String title;
  final String titleValue;
  final String subTitle;
  final String subTitleValue;
  final int progress;
  final Color? valueColor;
  final double padding;
  const PortofolioCardWidget({
    super.key,
    required this.isElite,
    required this.imgUrl,
    required this.title,
    required this.titleValue,
    required this.subTitle,
    required this.subTitleValue,
    required this.progress,
    required this.valueColor,
    this.padding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        color: isElite
            ? clrGreyE5e.withOpacity(0.12)
            : clrGreyE5e.withOpacity(0.25),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(imgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                        Text(
                          titleValue,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subTitle,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                        Text(
                          subTitleValue,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MainProgressBar(
                  bgColor: clrNeutralGrey999,
                  currentProgress: progress,
                  maxProgress: 100,
                  valueColor: valueColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "$progress%",
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
