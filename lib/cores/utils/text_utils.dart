import 'dart:math';

import 'package:flutter/material.dart';

class TextUtils {
  static double textScaleFactor(
    BuildContext context,
  ) {
    double maxTextScaleFactor = 2.5;
    final width = MediaQuery.of(context).size.width;
    if (width > 700) {
      double widthDiff = width - 700;
      int widthDiffMultiple = (widthDiff / 30).ceil();
      maxTextScaleFactor = 2.5 - (widthDiffMultiple * 0.06);
      print("maxTextScaleFactor: $maxTextScaleFactor");
      if (maxTextScaleFactor <= 1.48) {
        maxTextScaleFactor = 1.48;
      }
    }
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
