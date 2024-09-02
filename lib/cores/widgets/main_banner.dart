import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class MainBanner extends StatelessWidget {
  final Widget content;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;
  const MainBanner({
    super.key,
    required this.content,
    this.bgColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgColor ?? clrRed.withOpacity(0.2),
      ),
      child: content,
    );
  }
}
