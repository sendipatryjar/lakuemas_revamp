import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../blocs/gold_details_balances/gold_details_balances_bloc.dart';

class GoldDetailsBalanceWidget extends StatelessWidget {
  final bool isElite;
  const GoldDetailsBalanceWidget({super.key, required this.isElite});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

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
            title: Text(
              t.lblGoldDetails,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.goNamed(AppRoutes.beranda);
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              image: isElite
                  ? const DecorationImage(
                      image: AssetImage(imgBackgroundGold),
                      fit: BoxFit.cover,
                    )
                  : null,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  t.lblEffectiveGoldBalance,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite
                        ? clrDarkBrown.withOpacity(0.75)
                        : clrWhite.withOpacity(0.5),
                  ),
                ),
                BlocBuilder<GoldDetailsBalancesBloc, GoldDetailsBalancesState>(
                  builder: (context, state) {
                    String gold = '-';
                    if (state is GoldDetailsBalanceSuccessState) {
                      // gold = state.totalGold ?? '-';
                      gold = state.goldBalanceEntity?.gramationBalance ?? '-';
                    }

                    return RichText(
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      text: TextSpan(
                        text: gold.isEmpty ? '0' : gold,
                        style: DefaultTextStyle.of(context).style.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrDarkBrown : clrWhite,
                            ),
                        children: [
                          TextSpan(
                            text: '/gram',
                            style: DefaultTextStyle.of(context).style.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isElite ? clrDarkBrown : clrWhite,
                                ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isElite)
                      Image.asset(
                        icEliteColorfull,
                        height: 16,
                        width: 16,
                      ),
                    if (isElite) const SizedBox(width: 4),
                    BlocBuilder<GoldDetailsBalancesBloc,
                        GoldDetailsBalancesState>(
                      builder: (context, state) {
                        String goldNominal = '-';
                        if (state is GoldDetailsBalanceSuccessState) {
                          // goldNominal = state.totalNominal?.toIdr() ?? '-';
                          goldNominal = state.goldBalanceEntity?.nominalBalance
                                  ?.toIdr() ??
                              '-';
                        }
                        return Text(
                          '${t.lblWorth} ${goldNominal.isEmpty ? '0' : goldNominal}',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isElite
                                ? clrDarkBrown.withOpacity(0.75)
                                : clrWhite.withOpacity(0.5),
                          ),
                        );
                      },
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
