import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../blocs/physical_pull_gold_balance/physical_pull_gold_balance_bloc.dart';
import '../cubits/physical_pull_counter/physical_pull_counter_cubit.dart';

class PhysicalPullBalanceWidget extends StatelessWidget {
  final bool isElite;
  const PhysicalPullBalanceWidget({super.key, this.isElite = false});

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
            title: const Text(
              'Tarik Fisik',
              style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite
                        ? clrDarkBrown.withOpacity(0.75)
                        : clrWhite.withOpacity(0.5),
                  ),
                ),
                BlocBuilder<PhysicalPullGoldBalanceBloc,
                    PhysicalPullGoldBalanceState>(
                  builder: (context, state) {
                    String gold = '-';
                    if (state is PhysicalPullGoldBalanceSuccessState) {
                      gold = state.goldBalanceEntity?.gramationBalance ?? '-';
                      context.read<PhysicalPullCounterCubit>().getGoldBalance(
                          double.parse(
                                  state.goldBalanceEntity?.gramationBalance ??
                                      '0')
                              .toDouble());
                    }
                    return RichText(
                      text: TextSpan(
                        text: gold.isEmpty ? '0' : gold,
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
                    BlocBuilder<PhysicalPullGoldBalanceBloc,
                        PhysicalPullGoldBalanceState>(
                      builder: (context, state) {
                        String? nominal = '-';
                        if (state is PhysicalPullGoldBalanceSuccessState) {
                          nominal = state.goldBalanceEntity?.nominalBalance
                                  .toString()
                                  .toIdr() ??
                              '-';
                        }
                        return Text(
                          '${t.lblWorth} $nominal',
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
