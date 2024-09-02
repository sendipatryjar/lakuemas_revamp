import 'package:flutter/material.dart';
import '../../../../cores/constants/app_color.dart';

class PinSphereWidget extends StatelessWidget {
  final bool input;
  final bool isError;

  const PinSphereWidget({
    Key? key,
    required this.input,
    required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: input
              ? clrWhite.withOpacity(0.75)
              : isError
                  ? clrRed.withOpacity(0.4)
                  : clrWhite.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
