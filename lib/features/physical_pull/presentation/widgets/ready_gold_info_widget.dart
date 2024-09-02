import 'package:flutter/material.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';

class ReadyGoldInfoWidget extends StatelessWidget {
  const ReadyGoldInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1.5,
          color: clrBlue006.withOpacity(0.10),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            clrBlue006.withOpacity(0.16),
            clrBlue006.withOpacity(0.03),
          ],
        ),
      ),
      child: Row(
        children: [
          Image.asset(icInfo),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Emas akan ready di toko H+2 setelah pemesanan',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: clrBackgroundBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
