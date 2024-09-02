import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class PriceBoxWidget extends StatelessWidget {
  final bool isElite;
  final String titleReguler;
  final String titleElite;
  final String? date;
  final String? priceReguler;
  final String? priceElite;
  const PriceBoxWidget({
    super.key,
    required this.isElite,
    required this.titleReguler,
    required this.titleElite,
    this.date,
    this.priceReguler,
    this.priceElite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25),
                border: Border.all(
                  width: 2,
                  color: clrNeutralGrey999.withOpacity(0.16),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleReguler,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isElite
                        ? clrWhite.withOpacity(0.75)
                        : clrBackgroundBlack.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 10,
                    color: isElite
                        ? clrWhite.withOpacity(0.75)
                        : clrBackgroundBlack.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  priceReguler ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  clrYellow.withOpacity(0.8),
                  clrYellow.withOpacity(0.2),
                ],
              ),
              border: Border.all(
                width: 2,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      icEliteColorfull,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        titleElite,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isElite
                              ? clrWhite.withOpacity(0.75)
                              : clrBackgroundBlack.withOpacity(0.75),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  date ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 10,
                    color: isElite
                        ? clrWhite.withOpacity(0.75)
                        : clrBackgroundBlack.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  priceElite ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
