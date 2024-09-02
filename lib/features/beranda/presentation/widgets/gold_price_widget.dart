import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class GoldPriceWidget extends StatelessWidget {
  final String title;
  final String? price;
  final String? priceElite;
  final bool isElite;
  final bool isLoading;
  const GoldPriceWidget({
    super.key,
    required this.title,
    this.price,
    this.priceElite,
    this.isElite = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isElite) const SizedBox(width: 18),
            Text(
              isElite ? '$title Elite' : title,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isElite ? clrDarkBrown : clrWhite,
              ),
            ),
          ],
        ),
        if (isElite == false)
          isLoading
              ? Shimmer.fromColors(
                  baseColor: clrGreyShimmerBase,
                  highlightColor: clrGreyShimmerHighlight,
                  child: Container(
                    height: 10,
                    width: 64,
                    margin: const EdgeInsets.only(bottom: 4, top: 4),
                    decoration: BoxDecoration(
                      color: clrWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : Text(
                  price ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: clrWhite,
                  ),
                ),
        isLoading
            ? Shimmer.fromColors(
                baseColor: clrGreyShimmerBase,
                highlightColor: clrGreyShimmerHighlight,
                child: Container(
                  height: 10,
                  width: 72,
                  decoration: BoxDecoration(
                    color: clrWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            : Row(
                children: [
                  Image.asset(
                    icEliteColorfull,
                    height: isElite ? 14 : 12,
                    width: isElite ? 14 : 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    priceElite ?? '-',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: isElite ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrDarkBrown : clrOrange,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
