import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import 'label_discount_widget.dart';

class SubscriptionackagesWidget extends StatelessWidget {
  final bool isElite;
  final int itemLength;
  final String Function(int)? title;
  final String Function(int)? price;
  final String Function(int)? discPrice;
  final bool Function(int)? isShowBadgeDisc;
  final Widget Function(int)? radioBtn;
  final void Function(int)? onTap;

  const SubscriptionackagesWidget({
    super.key,
    required this.isElite,
    this.itemLength = 0,
    this.title,
    this.price,
    this.discPrice,
    this.isShowBadgeDisc,
    this.radioBtn,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.lblChoosePackages,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrDarkBlue,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(
            itemLength,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: () => onTap!(index),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isElite
                        ? clrGreyE5e.withOpacity(0.12)
                        : clrGreyE5e.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: clrNeutralGrey999.withOpacity(0.16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  title != null ? title!(index) : '',
                                  textScaler: TextScaler.linear(
                                      TextUtils.textScaleFactor(context)),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isElite ? clrWhite : clrBackgroundBlack,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                (isShowBadgeDisc!(index))
                                    ? const LabelDiscountWidget()
                                    : const SizedBox(),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 1,
                              width: double.infinity,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                            Text(
                              price!(index),
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                color: (isShowBadgeDisc!(index))
                                    ? (isElite ? clrWhite : clrNeutralGrey999)
                                    : isElite
                                        ? clrWhite
                                        : clrBackgroundBlack,
                                decoration: (discPrice != null)
                                    ? (isShowBadgeDisc!(index))
                                        ? TextDecoration.lineThrough
                                        : null
                                    : null,
                                decorationColor:
                                    isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                            (isShowBadgeDisc!(index))
                                ? Text(
                                    discPrice!(index),
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isElite
                                          ? clrWhite
                                          : clrBackgroundBlack,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: radioBtn!(index),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
