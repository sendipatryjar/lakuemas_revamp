import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../../../../cores/widgets/main_banner.dart';

class DebetTopWidget extends StatelessWidget {
  const DebetTopWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: clrBlack101,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: const Text(
              'Pembayaran Transaksi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              children: [
                Text(
                  "No. AE2331781",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: clrWhite.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 16),
                MainBanner(
                  bgColor: clrYellow.withOpacity(0.16),
                  content: Row(
                    children: [
                      Image.asset(
                        icWarningOrange,
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Pastikan untuk tidak menginformasikan data pembayaran kepada pihak manapun!",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: clrWhite,
                          ),
                        ),
                      ),
                    ],
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
