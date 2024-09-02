import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class FaqExpandableWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Color? iconColor;
  final List<Widget> children;
  const FaqExpandableWidget({
    super.key,
    required this.title,
    this.titleColor,
    this.iconColor,
    this.children = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: clrBackgroundBlack.withOpacity(0.08),
          ),
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: titleColor ?? clrBackgroundBlack,
              ),
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_down,
            color: iconColor ?? clrBackgroundBlack,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          children: children,
        ),
      ),
    );
  }
}
