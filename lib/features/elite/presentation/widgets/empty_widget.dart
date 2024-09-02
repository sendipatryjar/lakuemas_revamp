import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';

class EmptyWidget extends StatelessWidget {
  final String? imgAsset;
  final String? desc;
  const EmptyWidget({
    super.key,
    this.imgAsset,
    this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imgAsset ?? imgPeopleEmpty),
            const SizedBox(height: 32),
            Text(
              desc ?? '-',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: clrWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
