import 'package:flutter/material.dart';

import '../constants/app_color.dart';
import '../utils/text_utils.dart';

class CardListWidget extends StatelessWidget {
  final int itemLength;
  final String Function(int)? title;
  final Widget Function(int)? rightWidget;
  final String Function(int)? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final bool isUseDevider;
  final bool isUseRightArrow;
  final Widget? optionalWidget;
  final Widget? optionalBottomWidget;
  final Widget Function(int)? radioBtn;
  final void Function(int)? onTap;
  final Color? borderColor;
  final bool isElite;
  const CardListWidget({
    super.key,
    this.itemLength = 0,
    this.title,
    this.rightWidget,
    this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
    this.isUseDevider = true,
    this.isUseRightArrow = true,
    this.optionalWidget,
    this.optionalBottomWidget,
    this.radioBtn,
    this.onTap,
    this.borderColor,
    this.isElite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isElite
            ? clrGreyE5e.withOpacity(0.12)
            : clrGreyE5e.withOpacity(0.25),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor ??
              (isElite
                  ? clrNeutralGrey999.withOpacity(0.16)
                  : clrBackgroundBlack.withOpacity(0.08)),
        ),
      ),
      child: Column(
        children: [
          Container(
            child: optionalWidget,
          ),
          Column(
            children: List.generate(
                itemLength,
                (index) => Column(
                      children: [
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      title != null ? title!(index) : '-',
                                      style: titleStyle,
                                      textScaler: TextScaler.linear(
                                          TextUtils.textScaleFactor(context)),
                                    ),
                                  ),
                                  if (rightWidget != null) rightWidget!(index),
                                ],
                              ),
                              if (subTitle != null)
                                Text(
                                  subTitle!(index),
                                  style: subTitleStyle,
                                  textScaler: TextScaler.linear(
                                      TextUtils.textScaleFactor(context)),
                                ),
                            ],
                          ),
                          trailing: isUseRightArrow
                              ? Icon(
                                  Icons.keyboard_arrow_right,
                                  color:
                                      (isElite ? clrWhite : clrBackgroundBlack)
                                          .withOpacity(0.32),
                                )
                              : (radioBtn != null
                                  ? radioBtn!(index)
                                  : const SizedBox()),
                          onTap: onTap != null
                              ? () {
                                  onTap!(index);
                                }
                              : null,
                        ),
                        if (isUseDevider && index != (itemLength - 1))
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: clrBackgroundBlack.withOpacity(0.08),
                          ),
                      ],
                    )),
          ),
          Container(
            child: optionalBottomWidget,
          ),
        ],
      ),
    );
  }
}
