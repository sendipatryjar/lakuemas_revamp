import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class NumpadButtonWidget extends StatelessWidget {
  const NumpadButtonWidget({Key? key, required this.num, this.onPressed})
      : super(key: key);

  final String num;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: FloatingActionButton.extended(
        heroTag: num,
        elevation: 0,
        backgroundColor: clrBackgroundBlack,
        onPressed: onPressed,
        label: Text(
          num,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: clrWhite,
          ),
        ),
      ),
    );
  }
}
