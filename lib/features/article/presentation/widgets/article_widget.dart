import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class ArticleWidget extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? dateTime;
  final bool isElite;

  const ArticleWidget({
    super.key,
    required this.title,
    this.imageUrl,
    this.dateTime,
    this.isElite = false,
  });

  @override
  Widget build(BuildContext context) {
    double imageHeight = 80;
    double imageWidth = 80;
    return LayoutBuilder(builder: (_, ctr) {
      if (ctr.maxWidth > 627) {
        imageHeight = 120;
        imageWidth = 120;
      }
      if (ctr.maxWidth > 1240) {
        imageHeight = 160;
        imageWidth = 160;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: imageHeight,
                width: imageWidth,
                decoration: BoxDecoration(
                  // color: clrNeutralGrey999.withOpacity(0.32),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('no image')),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    Text(
                      dateTime ?? '-',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: clrNeutralGrey999,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}
