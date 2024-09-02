import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/card_list_widget.dart';

class SubscriptionSectionWidget extends StatelessWidget {
  final bool isElite;
  final String? title;
  final Widget Function(int)? rightWidget;
  final int itemLength;
  final String Function(int)? menuName;
  final void Function(int)? menuOnTap;
  final Widget Function(int)? radioBtn;
  final Widget? optionalWidget;
  const SubscriptionSectionWidget({
    super.key,
    required this.isElite,
    this.title,
    this.rightWidget,
    this.itemLength = 0,
    this.menuName,
    this.menuOnTap,
    this.radioBtn,
    this.optionalWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
        if (title != null) const SizedBox(height: 16),
        CardListWidget(
          isElite: isElite,
          itemLength: itemLength,
          title: menuName,
          optionalWidget: optionalWidget,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
          rightWidget: rightWidget,
          isUseRightArrow: false,
          radioBtn: radioBtn,
          onTap: menuOnTap,
        ),
      ],
    );
  }
}
