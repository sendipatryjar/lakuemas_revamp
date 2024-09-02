import 'package:flutter/material.dart';

import '../constants/app_color.dart';

class MainIconCircle extends StatelessWidget {
  final Size size;
  final IconData icon;
  final Widget? flag;
  final bool isElite;
  final Function()? onTap;
  const MainIconCircle({
    Key? key,
    this.size = const Size(36, 36),
    required this.icon,
    this.flag,
    this.isElite = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              border: Border.all(
                  color: (isElite ? clrDarkBrown : clrWhite).withOpacity(0.2)),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: (isElite ? clrDarkBrown : clrWhite).withOpacity(0.2),
            ),
          ),
          if (flag != null)
            Positioned(
              top: 0,
              right: 0,
              child: flag!,
            ),
        ],
      ),
    );
  }
}
