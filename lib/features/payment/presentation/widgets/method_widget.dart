import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class MethodWidget extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subTitle;
  final int? methodId;
  final int? selectedMethodId;
  final EdgeInsetsGeometry? contentPadding;
  final bool isElite;
  final Function(int?)? onChanged;
  const MethodWidget({
    Key? key,
    this.imageUrl,
    this.title = 'Transfer Via VA',
    this.subTitle,
    this.methodId,
    this.selectedMethodId,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.isElite = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (methodId != null && selectedMethodId != null)
          Container(
            height: 1,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: (isElite ? clrWhite : clrNeutralGrey999).withOpacity(0.16),
          ),
        ListTile(
          contentPadding: contentPadding,
          leading: CircleAvatar(
            backgroundColor: clrWhite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: imageUrl != null
                  ? Image.network(imageUrl!)
                  : const SizedBox(),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              if (subTitle != null)
                Text(
                  subTitle!,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
            ],
          ),
          trailing: methodId != null
              ? Radio<int?>(
                  value: methodId,
                  groupValue: selectedMethodId,
                  onChanged: onChanged,
                  fillColor: MaterialStateColor.resolveWith((states) =>
                      (isElite ? clrWhite : clrBackgroundBlack)
                          .withOpacity(0.75)),
                )
              : null,
        ),
      ],
    );
  }
}
