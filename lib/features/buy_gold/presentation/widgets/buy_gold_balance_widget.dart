import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/utils/app_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../../../_core/transaction/domain/entities/price_entity.dart';
import '../blocs/balance/bgold_balance_bloc.dart';
import '../cubits/buy_gold/buy_gold_cubit.dart';

class BuyGoldBalanceWidget extends StatelessWidget {
  final bool isElite;
  final bool isFromElite;
  final bool isFromGrafik;
  final PriceEntity? priceEntity;
  final String? backScreen;
  final Map<String, dynamic>? extra;
  const BuyGoldBalanceWidget({
    super.key,
    this.isElite = false,
    this.isFromElite = false,
    this.isFromGrafik = false,
    this.priceEntity,
    this.backScreen,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    appPrint("is grafik : $isFromGrafik");
    appPrint("is grafik : $priceEntity");
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
              '${t.lblBuy} ${t.lblGold}',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                if (isFromElite) {
                  context.goNamed(AppRoutes.elite, extra: extra);
                } else if (isFromGrafik) {
                  context.goNamed(
                    AppRoutes.goldPriceChart,
                    extra: {
                      'priceEntity': priceEntity,
                      ...(extra ?? {}),
                      'isElite': isElite.toString(),
                    },
                  );
                } else {
                  context.goNamed(backScreen ?? AppRoutes.beranda,
                      extra: extra);
                }
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
                BlocBuilder<BgoldBalanceBloc, BgoldBalanceState>(
                  builder: (context, state) {
                    if (state is BgoldBalanceLoadingState) {
                      return Shimmer.fromColors(
                        baseColor: clrGreyShimmerBase,
                        highlightColor: clrGreyShimmerHighlight,
                        child: Container(
                          width: 160,
                          height: 32,
                          decoration: BoxDecoration(
                            color: clrWhite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }
                    return BlocBuilder<BuyGoldCubit, BuyGoldState>(
                      buildWhen: (previous, current) =>
                          previous.balanceEntity?.gramationBalance !=
                          current.balanceEntity?.gramationBalance,
                      builder: (context, state) {
                        var goldBalance =
                            state.balanceEntity?.gramationBalance ?? '-';
                        return RichText(
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
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
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                BlocBuilder<BgoldBalanceBloc, BgoldBalanceState>(
                  builder: (context, state) {
                    if (state is BgoldBalanceLoadingState) {
                      return Shimmer.fromColors(
                        baseColor: clrGreyShimmerBase,
                        highlightColor: clrGreyShimmerHighlight,
                        child: Container(
                          width: 120,
                          height: 24,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: clrWhite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }
                    return BlocBuilder<BuyGoldCubit, BuyGoldState>(
                      buildWhen: (previous, current) =>
                          previous.balanceEntity?.nominalBalance !=
                          current.balanceEntity?.nominalBalance,
                      builder: (context, state) {
                        var nominalBalance =
                            state.balanceEntity?.nominalBalance != null
                                ? state.balanceEntity?.nominalBalance?.toIdr()
                                : '-';
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isElite)
                              Image.asset(
                                icEliteColorfull,
                                height: 16,
                                width: 16,
                              ),
                            if (isElite) const SizedBox(width: 4),
                            Text(
                              '${t.lblWorth} $nominalBalance',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isElite
                                    ? clrDarkBrown.withOpacity(0.75)
                                    : clrWhite.withOpacity(0.5),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
