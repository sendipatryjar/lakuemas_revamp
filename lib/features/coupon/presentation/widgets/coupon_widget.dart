import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class CouponWidget extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final Color? titleColor;
  final String? subTitle;
  final Color? subTitleColor;
  // final double height;
  final Color? bgColor;
  final Function()? onTap;
  const CouponWidget({
    Key? key,
    this.imageUrl,
    required this.title,
    this.titleColor,
    this.subTitle,
    this.subTitleColor,
    // this.height = 222,
    this.bgColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 222;
    return LayoutBuilder(builder: (_, ctr) {
      if (ctr.maxWidth > 627) {
        height = 320;
      }
      if (ctr.maxWidth > 1240) {
        height = 376;
      }
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor ?? clrNeutralGrey999.withOpacity(0.128),
            border: Border.all(width: 1, color: clrWhite.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: clrYellow,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Image.network(
                      imageUrl ?? '',
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          'no image',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    if (subTitle != null) const SizedBox(height: 8),
                    if (subTitle != null)
                      Text(
                        subTitle!,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: subTitleColor,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
