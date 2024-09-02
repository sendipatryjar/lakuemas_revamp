import 'package:flutter/material.dart';
import '../../../../cores/constants/app_color.dart';

import '../../../../cores/constants/img_assets.dart';

class EmptyTrxWidget extends StatelessWidget {
  final bool isElite;
  const EmptyTrxWidget({super.key, required this.isElite});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imgPeopleRedeemWrong),
        const SizedBox(height: 32),
        Text(
          'Mohon maaf, data filter belum tersedia',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        )
      ],
    );
  }
}
