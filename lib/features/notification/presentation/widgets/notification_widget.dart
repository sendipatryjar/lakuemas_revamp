import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_button.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? iconUrl;
  final String? date;
  final Color? textColor;
  final Color? bgColor;
  final String? imageUrl;
  final Function()? btnOnPressed;
  final Function()? onNotifPressed;

  const NotificationWidget({
    super.key,
    required this.title,
    this.subTitle,
    this.iconUrl,
    this.date,
    this.textColor,
    this.bgColor,
    this.imageUrl,
    this.btnOnPressed,
    this.onNotifPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNotifPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: bgColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const CircleAvatar(),
                    ClipOval(
                      child: Image.network(
                        iconUrl ?? '',
                        height: 36,
                        width: 36,
                        errorBuilder: (context, error, stackTrace) =>
                            const CircleAvatar(
                          radius: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imageUrl != null)
                            Container(
                                height: 96,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: clrYellow,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.network(
                                  imageUrl ?? '',
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(child: Text('no image')),
                                )),
                          Text(
                            title,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textColor ?? clrBackgroundBlack,
                            ),
                          ),
                          if ((subTitle ?? '').isNotEmpty)
                            const SizedBox(height: 2),
                          if ((subTitle ?? '').isNotEmpty)
                            Text(
                              subTitle!,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: (textColor ?? clrBackgroundBlack)
                                    .withOpacity(0.75),
                              ),
                            ),
                          if (btnOnPressed != null)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: MainButton(
                                label: 'Baca Artikel >>',
                                borderRadius: 30,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                onPressed: btnOnPressed,
                              ),
                            ),
                          if ((date ?? '').isNotEmpty)
                            const SizedBox(height: 2),
                          if ((date ?? '').isNotEmpty)
                            Text(
                              date!,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: (textColor ?? clrBackgroundBlack)
                                    .withOpacity(0.75),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
        ],
      ),
    );
  }
}
