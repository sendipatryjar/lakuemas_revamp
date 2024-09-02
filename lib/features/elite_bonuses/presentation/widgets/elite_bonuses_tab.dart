import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../cores/constants/app_color.dart';
import '../cubits/elite_bonuses_tab/elite_bonuses_tab_cubit.dart';
import 'empty_bonuses_widget.dart';

class EliteBonusesTab extends StatelessWidget {
  final bool isElite;
  const EliteBonusesTab({super.key, required this.isElite});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BlocBuilder<EliteBonusesTabCubit, EliteBonusesTabState>(
                builder: (context, state) {
                  return _tab(
                    title: '${t.lblTrade} ${t.lblBonuses}',
                    isSelected:
                        state.enEliteBonusTab == EnEliteBonusTab.tradeBonus,
                    onTap: () {
                      context
                          .read<EliteBonusesTabCubit>()
                          .changeTab(EnEliteBonusTab.tradeBonus);
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: BlocBuilder<EliteBonusesTabCubit, EliteBonusesTabState>(
                builder: (context, state) {
                  return _tab(
                    title: '${t.lblReward} ${t.lblMe}',
                    isSelected:
                        state.enEliteBonusTab == EnEliteBonusTab.myReward,
                    onTap: () {
                      context
                          .read<EliteBonusesTabCubit>()
                          .changeTab(EnEliteBonusTab.myReward);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<EliteBonusesTabCubit, EliteBonusesTabState>(
          builder: (context, state) {
            return state.enEliteBonusTab == EnEliteBonusTab.tradeBonus
                ? _tradeBonusesSection(isElite)
                : state.enEliteBonusTab == EnEliteBonusTab.myReward
                    ? _myRewardSection(isElite)
                    : const SizedBox();
          },
        )
      ],
    );
  }

  Widget _tab({
    required String title,
    bool isSelected = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? clrYellow : clrNeutralGrey999.withOpacity(0.16),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? clrBackgroundBlack
                : (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75),
          ),
        ),
      ),
    );
  }

  Widget _tradeBonusesSection(bool isElite) {
    return Column(
      children: [
        Center(
          child: EmptyBonusesWidget(isElite: isElite),
        ),
      ],
    );
  }

  Widget _myRewardSection(bool isElite) {
    return Column(
      children: [
        EmptyBonusesWidget(isElite: isElite),
      ],
    );
  }
}
