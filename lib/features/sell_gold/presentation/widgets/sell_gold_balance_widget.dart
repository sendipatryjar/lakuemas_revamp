import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../../../_core/transaction/domain/entities/price_entity.dart';
import '../blocs/balance/sgold_balance_bloc.dart';

class SellGoldBalanceWidget extends StatelessWidget {
  final bool isElite;
  final bool isFromGrafik;
  final PriceEntity? priceEntity;
  const SellGoldBalanceWidget(
      {super.key,
      this.isElite = false,
      this.isFromGrafik = false,
      this.priceEntity});

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
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              '${t.lblSell} ${t.lblGold}',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                isFromGrafik
                    ? context.goNamed(
                        AppRoutes.goldPriceChart,
                        extra: {'priceEntity': priceEntity},
                      )
                    : context.goNamed(AppRoutes.beranda);
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
                BlocBuilder<SgoldBalanceBloc, SgoldBalanceState>(
                  builder: (context, state) {
                    String goldBalance = '-';
                    if (state is SgoldBalanceSuccessState) {
                      goldBalance =
                          state.balanceEntity?.gramationBalance ?? '-';
                    }
                    return RichText(
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      text: TextSpan(
                        text: goldBalance.isEmpty ? '0' : goldBalance,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrDarkBrown : clrWhite,
                        ),
                        children: const [
                          TextSpan(
                            text: '/gram',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              // color: clrWhite,
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
                    BlocBuilder<SgoldBalanceBloc, SgoldBalanceState>(
                      builder: (context, state) {
                        String? equalsTo;
                        if (state is SgoldBalanceSuccessState) {
                          equalsTo =
                              state.balanceEntity?.nominalBalance?.toIdr();
                        }
                        return Text(
                          '${t.lblWorth} ${equalsTo ?? '-'}',
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
