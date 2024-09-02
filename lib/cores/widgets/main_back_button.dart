import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class MainBackButton extends StatelessWidget {
  final Color? color;
  final Function()? onPressed;
  const MainBackButton({super.key, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      color: color ?? clrYellow,
      onPressed: onPressed,
    );
  }
}
