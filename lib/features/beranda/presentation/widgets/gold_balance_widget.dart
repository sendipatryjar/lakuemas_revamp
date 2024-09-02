import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';
import '../blocs/balance/balance_bloc.dart';

class GoldBalanceWidget extends StatelessWidget {
  final bool isElite;
  const GoldBalanceWidget({super.key, this.isElite = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        context.goNamed(
          AppRoutes.goldDetails,
          extra: {'isElite': isElite.toString()},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.lblGoldBalance,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isElite ? clrDarkBrown : clrWhite,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: clrOrange.withOpacity(0.1),
                    border: Border.all(color: clrOrange.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
                    builder: (context, state) {
                      String gold = '-';
                      if (state is BerandaBalancesSuccessState) {
                        gold = state.goldBalanceEntity?.gramationBalance ?? '-';
                      }
                      return Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: gold.isEmpty ? '0' : gold,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrDarkBrown : clrYellow,
                              ),
                            ),
                            TextSpan(
                              text: ' gr',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isElite ? clrDarkBrown : clrYellow,
                              ),
                            ),
                          ],
                        ),
                        softWrap: true,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
            builder: (context, state) {
              String goldNominal = '-';
              if (state is BerandaBalancesSuccessState) {
                goldNominal =
                    state.goldBalanceEntity?.nominalBalance?.toIdr() ?? '-';
              }
              return RichText(
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                text: TextSpan(
                  text: t.lblWorth,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isElite ? clrDarkBrown : clrWhite,
                  ),
                  children: [
                    TextSpan(
                      text: ' Rp ${goldNominal.isNotEmpty ? goldNominal : '0'}',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
