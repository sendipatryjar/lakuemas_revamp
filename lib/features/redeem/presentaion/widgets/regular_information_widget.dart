import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/extensions/currency_extension.dart';

import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';

class RegulerInformationWidget extends StatelessWidget {
  final String? priceRedeemReguler;
  final String? priceRedeemElite;
  const RegulerInformationWidget({
    super.key,
    this.priceRedeemReguler,
    this.priceRedeemElite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Redeem Lebih Murah Dengan Lakuemas Elite!',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nikmati penawaran harga istimewa jika kamu berlangganan Lakuemas Elite sekarang!',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: clrBackgroundBlack.withOpacity(0.75),
          ),
        ),
        const Divider(height: 33),
        Text(
          'Harga Redeem Nasabah Reguler',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: clrBackgroundBlack.withOpacity(0.75),
          ),
        ),
        Text(
          'Rp ${priceRedeemReguler.toIdr()}',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: clrBackgroundBlack.withOpacity(0.75),
          ),
        ),
        const Divider(height: 33),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Harga Redeem Nasabah Elite',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: clrOrange,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              icEliteColorfull,
              height: 18,
              width: 18,
            ),
          ],
        ),
        Text(
          'Rp ${priceRedeemElite.toIdr()}',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            context.goNamed(AppRoutes.elite);
          },
          child: Text(
            'Klik disini untuk Join Lakuemas Elite >',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: clrBackgroundBlack,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
