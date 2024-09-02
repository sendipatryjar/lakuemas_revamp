import 'package:flutter/material.dart';

import '../constants/app_color.dart';
import '../utils/text_utils.dart';

class MainButton extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final TextAlign labelTextAlign;
  final Color? bgColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final BorderSide? border;
  final Function()? onPressed;
  final Widget? leadingWidget;
  final bool isExpandedLabel;
  const MainButton({
    super.key,
    required this.label,
    this.labelStyle,
    this.labelTextAlign = TextAlign.center,
    this.bgColor,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 15,
    this.border,
    this.onPressed,
    this.leadingWidget,
    this.isExpandedLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null
          ? () {
              FocusManager.instance.primaryFocus?.unfocus();
              onPressed!();
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? clrYellow,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: border,
        disabledForegroundColor: clrNeutralGrey999,
        disabledBackgroundColor: clrNeutralGrey999,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingWidget != null) ...[
            leadingWidget!,
            const SizedBox(
              width: 24,
            ),
            isExpandedLabel
                ? Expanded(
                    child: _text(context),
                  )
                : _text(context),
          ] else ...[
            _text(context),
          ],
        ],
      ),
    );
  }

  Widget _text(BuildContext context) => Text(
        label,
        textAlign: labelTextAlign,
        textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
        style: labelStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: clrBackgroundBlack,
            ),
      );
}
