import 'package:flutter/material.dart';

import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/card_list_widget.dart';

class ProfileSectionWidget extends StatelessWidget {
  final String? title;
  final Widget Function(int)? rightWidget;
  final int itemLength;
  final String Function(int)? menuName;
  final void Function(int)? menuOnTap;
  const ProfileSectionWidget({
    super.key,
    this.title,
    this.rightWidget,
    this.itemLength = 0,
    this.menuName,
    this.menuOnTap,
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (title != null) const SizedBox(height: 16),
        CardListWidget(
          itemLength: itemLength,
          title: menuName,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          rightWidget: rightWidget,
          onTap: menuOnTap,
        ),
      ],
    );
  }
}
