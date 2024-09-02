import 'package:flutter/material.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class ReferralCardWidget extends StatelessWidget {
  final String? name;
  final String? eliteRegDate;
  final String? eliteExpDate;
  final bool isExpired;
  const ReferralCardWidget({
    super.key,
    this.name,
    this.eliteRegDate,
    this.eliteExpDate,
    this.isExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: clrWhite.withOpacity(0.75),
    );

    final TextStyle valueStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: clrWhite,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        // color: clrGreyE5e.withOpacity(0.12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isExpired
              ? [
                  clrRed.withOpacity(0.2),
                  clrRed.withOpacity(0.1),
                ]
              : [
                  clrGreyE5e.withOpacity(0.12),
                  clrGreyE5e.withOpacity(0.12),
                ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nama',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: labelStyle,
              ),
              Text(
                name ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: valueStyle,
              ),
            ],
          ),
          Divider(
            height: 32,
            thickness: 1,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tanggal register elite',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: labelStyle,
              ),
              Text(
                eliteRegDate ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: valueStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tanggal berakhir elite',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: labelStyle,
              ),
              Text(
                eliteExpDate ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: valueStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
