import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../cores/utils/text_utils.dart';
import '../beranda_screen.dart';
import '../blocs/beranda_menus/beranda_menus_bloc.dart';
import '../blocs/price_setting/price_setting_bloc.dart';
import 'gold_balance_widget.dart';
import 'gold_price_widget.dart';

class HomeGoldBalanceCard extends StatelessWidget {
  final bool isElite;
  final double? height;
  const HomeGoldBalanceCard({super.key, this.isElite = false, this.height});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: clrNeutralGrey999.withOpacity(0.128),
        border: Border.all(color: clrWhite.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 9,
                      child: GoldBalanceWidget(isElite: isElite),
                    ),
                    Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          Container(
                            height: 88,
                            width: 1,
                            color: (isElite ? clrDarkBrown : clrWhite)
                                .withOpacity(0.2),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          const Spacer(flex: 2),
                          GestureDetector(
                            onTap: () {
                              var priceEtt = context
                                  .read<HelperDataCubit>()
                                  .state
                                  .priceSettings;
                              context.goNamed(AppRoutes.goldPriceChart, extra: {
                                'priceEntity': priceEtt,
                                'isElite': isElite.toString()
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                BlocBuilder<PriceSettingBloc,
                                    PriceSettingState>(
                                  builder: (context, state) {
                                    String? price;
                                    String? priceElite;
                                    if (state is PriceSettingSuccessState) {
                                      price = state.priceEntity.sellingPrice;
                                      priceElite =
                                          state.priceEntity.eliteSellingPrice;
                                    }
                                    return GoldPriceWidget(
                                      title: t.lblPurchasePrice,
                                      price: 'Rp ${price?.toIdr()}',
                                      priceElite: 'Rp ${priceElite?.toIdr()}',
                                      isElite: isElite,
                                      isLoading:
                                          state is PriceSettingLoadingState,
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                BlocBuilder<PriceSettingBloc,
                                    PriceSettingState>(
                                  builder: (context, state) {
                                    String? price;
                                    String? priceElite;
                                    if (state is PriceSettingSuccessState) {
                                      price = state.priceEntity.purchasePrice;
                                      priceElite =
                                          state.priceEntity.elitePurchasePrice;
                                    }
                                    return GoldPriceWidget(
                                      title: t.lblSellingPrice,
                                      price: 'Rp ${price?.toIdr()}',
                                      priceElite: 'Rp ${priceElite?.toIdr()}',
                                      isElite: isElite,
                                      isLoading:
                                          state is PriceSettingLoadingState,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 111,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: clrNeutralGrey999.withOpacity(0.2),
              border: Border.all(color: clrWhite.withOpacity(0.2)),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: BlocBuilder<BerandaMenusBloc, BerandaMenusState>(
              builder: (context, state) {
                if (state is BerandaMenusLoadingState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        4,
                        (index) => Shimmer.fromColors(
                              baseColor: clrGreyShimmerBase,
                              highlightColor: clrGreyShimmerHighlight,
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: clrWhite,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            )),
                  );
                }
                if (state is BerandaMenusSuccessState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: state.menuPrimary
                        .map(
                          (e) => _icon(
                            context: context,
                            icon: _assetIconPrimary(e.id ?? 0, isElite),
                            label: e.name ?? '-',
                            labelColor: isElite ? clrBlack1d2 : clrWhite,
                            onTap: () {
                              if (e.isActive == 1) {
                                menuOnTap(
                                    context,
                                    e.id ?? 0,
                                    isElite,
                                    context
                                        .read<HelperDataCubit>()
                                        .state
                                        .userDataEntity);
                              }
                            },
                          ),
                        )
                        .toList(),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(
      {required BuildContext context,
      required String icon,
      String? label,
      Color? labelColor,
      Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            icon,
            height: 52,
            width: 52,
          ),
          if (label != null) ...[
            const SizedBox(height: 4),
            Text(
              label,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            )
          ]
        ],
      ),
    );
  }

  String _assetIconPrimary(int id, bool isElite) {
    switch (id) {
      case 1:
        if (isElite) return icGoldBuyElite;
        return icGoldBuyReguler;
      case 2:
        if (isElite) return icGoldSellElite;
        return icGoldSellReguler;
      case 3:
        if (isElite) return icGoldRedeemElite;
        return icGoldRedeemReguler;
      case 4:
        return icGoldPhysicalPull;
      case 5:
        if (isElite) return icGoldSaveElite;
        return icGoldSaveReguler;
      default:
        return icGoldBuyReguler;
    }
  }
}
