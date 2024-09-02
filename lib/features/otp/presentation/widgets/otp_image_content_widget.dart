import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class OtpImageContentWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? username;
  const OtpImageContentWidget({
    Key? key,
    this.title = 'OTP',
    this.subTitle,
    this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imgOtpVerification),
        const SizedBox(height: 24),
        Text(
          title,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: clrWhite,
          ),
        ),
        if (subTitle != null) const SizedBox(height: 8),
        if (subTitle != null)
          if (username == null)
            Text(
              subTitle!,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: clrWhite,
              ),
            ),
        if (username != null)
          RichText(
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            textAlign: TextAlign.center,
            text: TextSpan(
              text: subTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: clrWhite,
              ),
              children: [
                TextSpan(
                    text: username,
                    style: TextStyle(
                      color: clrYellow,
                    )),
              ],
            ),
          ),
      ],
    );
  }
}
