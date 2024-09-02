import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class CardOfferWidget extends StatelessWidget {
  final String? title;
  final String? claimed;
  final String? activeUntil;
  final String? imageUrl;
  const CardOfferWidget({
    super.key,
    this.title,
    this.claimed,
    this.activeUntil,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: clrWhite.withOpacity(0.20),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            clrNeutralGrey999.withOpacity(0.12),
            clrNeutralGrey999.withOpacity(0.06)
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 144,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              image: (imageUrl ?? '').isEmpty || imageUrl == null
                  ? const DecorationImage(
                      image: AssetImage(imgCardOffer),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage(imageUrl ?? ''),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: clrWhiteFef,
                  ),
                ),
                if (claimed != null) const SizedBox(height: 4),
                if (claimed != null)
                  Text(
                    claimed ?? '-',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: clrWhite.withOpacity(0.75),
                    ),
                  ),
                if (activeUntil != null) const SizedBox(height: 4),
                if (activeUntil != null)
                  Text(
                    activeUntil ?? '-',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: clrWhite.withOpacity(0.75),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
