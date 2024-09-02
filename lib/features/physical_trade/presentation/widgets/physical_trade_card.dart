import 'package:flutter/material.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhysicalTradeCard extends StatelessWidget {
  final bool isElite;
  final int? stock;
  const PhysicalTradeCard({super.key, required this.isElite, this.stock});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isElite
            ? clrGreyE5e.withOpacity(0.12)
            : stock == 0
                ? clrNeutralGrey999.withOpacity(0.32)
                : clrGreyE5e.withOpacity(0.25),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: isElite
              ? clrNeutralGrey999.withOpacity(0.16)
              : stock == 0
                  ? clrNeutralGrey999.withOpacity(0.16)
                  : clrNeutralGrey999.withOpacity(0.16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imgGold,
            width: 56,
            height: 88,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Antam Certieye 1 Gram',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.lblPrice,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Rp ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                        children: [
                          TextSpan(
                            text: '1.076.000',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${t.lblDigitalTrade} (${t.lblGram})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    Text(
                      '1.1999',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    stock == 0
                        ? Text(
                            'Stok Habis',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: clrRed,
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: isElite
                                  ? clrGreyE5e.withOpacity(0.12)
                                  : clrGreyE5e.withOpacity(0.25),
                              border: Border.all(
                                width: 2,
                                color: clrNeutralGrey999.withOpacity(0.16),
                              ),
                            ),
                            child: Text(
                              'Remove All',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isElite
                                    ? clrWhite.withOpacity(0.50)
                                    : clrBackgroundBlack.withOpacity(0.50),
                              ),
                            ),
                          ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isElite
                                ? clrGreyE5e.withOpacity(0.12)
                                : stock == 0
                                    ? clrNeutralGrey999.withOpacity(0.32)
                                    : clrGreyE5e.withOpacity(0.25),
                            border: Border.all(
                              width: 2,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                          ),
                          child: Text(
                            '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '0',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: clrYellow.withOpacity(0.75),
                            border: Border.all(
                              width: 2,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                          ),
                          child: Text(
                            '+',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
