import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../../features/beranda/presentation/blocs/balance/balance_bloc.dart';
import '../extensions/currency_extension.dart';
import '../constants/app_color.dart';
import '../constants/img_assets.dart';
import '../utils/text_utils.dart';

class MainCardBalanceWidget extends StatelessWidget {
  final bool isElite;
  const MainCardBalanceWidget({super.key, this.isElite = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: clrBlack101,
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
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isElite
                  ? clrDarkBrown.withOpacity(0.75)
                  : clrWhite.withOpacity(0.5),
            ),
          ),
          BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
            builder: (context, state) {
              if (state is BerandaBalancesLoadingState) {
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
              if (state is BerandaBalancesSuccessState) {
                return RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                    text: (state.goldBalanceEntity?.gramationBalance ?? '')
                            .isEmpty
                        ? '0'
                        : state.goldBalanceEntity?.gramationBalance,
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
              }
              return const SizedBox();
            },
          ),
          BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
            builder: (context, state) {
              if (state is BerandaBalancesLoadingState) {
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
              if (state is BerandaBalancesSuccessState) {
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
                      '${t.lblWorth} ${(state.goldBalanceEntity?.nominalBalance ?? 0).toIdr()}',
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
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
