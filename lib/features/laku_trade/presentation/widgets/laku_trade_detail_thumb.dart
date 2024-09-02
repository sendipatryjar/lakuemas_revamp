import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/widgets/main_back_button.dart';

class LakuTradeDetailThumb extends StatelessWidget {
  final bool isElite;
  const LakuTradeDetailThumb({super.key, required this.isElite});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: clrBlue141,
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
            title: Text(
              'Laku ${t.lblTrade}',
              style: const TextStyle(
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                Image.asset(imgGold),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 37,
                  ),
                  decoration: BoxDecoration(
                    color: clrGreyE5e.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      width: 1,
                      color: clrNeutralGrey999.withOpacity(0.16),
                    ),
                  ),
                  child: Text(
                    'Antam • 10 Gram',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: clrYellow,
                    ),
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
