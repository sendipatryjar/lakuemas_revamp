import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class LabelDiscountWidget extends StatelessWidget {
  const LabelDiscountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: clrGreen00B,
        ),
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            (clrGreen00B).withOpacity(0.2),
            (clrGreen00B).withOpacity(0.1),
          ],
        ),
      ),
      child: Text(
        'Harga Spesial',
        textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: clrGreen00A,
        ),
      ),
    );
  }
}
