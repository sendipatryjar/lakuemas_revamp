import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_color.dart';
import '../../constants/img_assets.dart';
import '../../routes/app_routes.dart';
import '../../utils/text_utils.dart';
import '../main_button.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "404",
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 64,
              color: clrBackgroundBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Page Not Found",
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: clrBackgroundBlack,
            ),
          ),
          Image.asset(
            imgErrorServer,
            height: 200,
            width: 335,
          ),
          const SizedBox(height: 32),
          Text(
            "Oops, halaman yang anda cari tidak ditemukan.",
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: clrBackgroundBlack,
            ),
          ),
          const SizedBox(height: 32),
          MainButton(
            label: "kembali ke halaman utama",
            onPressed: () async {
              context.goNamed(await AppRoutes.initialRoute);
            },
          ),
        ],
      ),
    );
  }
}
