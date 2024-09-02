import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/app_color.dart';
import '../constants/img_assets.dart';
import '../widgets/main_button.dart';

class DialogUtils {
  static success({
    required BuildContext context,
    bool barrierDismissible = false,
    bool isShowIcon = true,
    String? btnText,
    String? firstDesc,
    Widget? firstDescWidget,
    String? secondDesc,
    Function()? btnOnPressed,
  }) {
    final t = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          backgroundColor: clrBackgroundBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              width: 3,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (isShowIcon == false)
                  ? const SizedBox()
                  : Image.asset(icCheckCircle),
              const SizedBox(height: 20),
              firstDescWidget ??
                  Text(
                    firstDesc ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: clrWhite,
                    ),
                  ),
              if (secondDesc != null) const SizedBox(height: 8),
              if (secondDesc != null)
                Text(
                  secondDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: clrWhite,
                  ),
                ),
              if (btnText != null || btnOnPressed != null)
                const SizedBox(height: 40),
              if (btnText != null || btnOnPressed != null)
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    label: btnText ?? t.lblBack,
                    onPressed: btnOnPressed,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static failure({
    required BuildContext context,
    bool barrierDismissible = false,
    bool isShowIcon = true,
    String? btnText,
    String? firstDesc,
    String? secondDesc,
    Function()? btnOnPressed,
  }) {
    final t = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          backgroundColor: clrBackgroundBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              width: 3,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (isShowIcon == false)
                  ? const SizedBox()
                  : Image.asset(icCrossCircle),
              const SizedBox(height: 20),
              Text(
                firstDesc ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: clrWhite,
                ),
              ),
              if (secondDesc != null) const SizedBox(height: 8),
              if (secondDesc != null)
                Text(
                  secondDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: clrWhite,
                  ),
                ),
              if (btnText != null || btnOnPressed != null)
                const SizedBox(height: 40),
              if (btnText != null || btnOnPressed != null)
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    label: btnText ?? t.lblBack,
                    onPressed: btnOnPressed,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static Future<T?> confirm<T>({
    required BuildContext context,
    bool barrierDismissible = false,
    bool? isShowIcon = true,
    String? btnText,
    String? btnTextLater,
    String? firstDesc,
    String? secondDesc,
    Function()? btnConfirm,
    Function()? btnLater,
  }) {
    final t = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          backgroundColor: clrBackgroundBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              width: 3,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (isShowIcon == false)
                  ? const SizedBox()
                  : Image.asset(icWarningYellow),
              const SizedBox(height: 20),
              Text(
                firstDesc ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: clrWhite,
                ),
              ),
              if (secondDesc != null) const SizedBox(height: 8),
              if (secondDesc != null)
                Text(
                  secondDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: clrWhite,
                  ),
                ),
              if (btnText != null || btnConfirm != null)
                const SizedBox(height: 40),
              if (btnText != null || btnConfirm != null)
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    label: btnText ?? t.lblBack,
                    onPressed: btnConfirm,
                  ),
                ),
              const SizedBox(height: 20),
              if (btnText != null || btnConfirm != null)
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    label: btnTextLater ?? t.lblBack,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: clrYellow,
                    ),
                    bgColor: Colors.transparent,
                    onPressed: btnLater,
                    border: BorderSide(
                      width: 2,
                      color: clrYellow,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static universal({
    required BuildContext context,
    Widget? icon,
    bool barrierDismissible = false,
    String? btnText,
    String? firstDesc,
    String? secondDesc,
    Function()? btnConfirm,
  }) {
    final t = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          backgroundColor: clrBackgroundBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              width: 3,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) icon,
              const SizedBox(height: 20),
              Text(
                firstDesc ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: clrWhite,
                ),
              ),
              if (secondDesc != null) ...[
                const SizedBox(height: 8),
                Text(
                  secondDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: clrWhite,
                  ),
                ),
              ],
              if (btnText != null || btnConfirm != null) ...[
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    label: btnText ?? t.lblBack,
                    onPressed: btnConfirm,
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
