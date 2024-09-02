import 'package:flutter/material.dart';

import '../constants/app_color.dart';
import '../utils/text_utils.dart';

class LabelStatusWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;

  const LabelStatusWidget({
    super.key,
    this.text,
    this.textColor,
    this.bgColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        border: borderColor != null
            ? Border.all(
                width: 1,
                color: borderColor!,
              )
            : null,
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            (bgColor ?? clrRed).withOpacity(0.2),
            (bgColor ?? clrRed).withOpacity(0.1),
          ],
        ),
      ),
      child: Text(
        text ?? 'Belum Verifikasi',
        textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textColor ?? clrRed,
        ),
      ),
    );
  }
}
