import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/widgets/main_back_button.dart';

class BonusesHistoryTopWidget extends StatelessWidget {
  final bool isElite;
  const BonusesHistoryTopWidget({super.key, this.isElite = false});

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
            title: const Text(
              'Riwayat Bonus',
              style: TextStyle(
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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    clrNeutralGrey999.withOpacity(0.12),
                    clrNeutralGrey999.withOpacity(0.06),
                  ],
                ),
                border: Border.all(
                  width: 1,
                  color: clrWhite.withOpacity(0.20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${t.lblBonuses} ${t.lblMe}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrDarkBrown : clrWhite,
                            ),
                          ),
                          const SizedBox(width: 4),
                          isElite
                              ? GestureDetector(
                                  onTap: () => context.goNamed(
                                    AppRoutes.bonusEliteDetails,
                                    extra: {
                                      'eliteCubit': context.read<EliteCubit>(),
                                      'backScreen': AppRoutes.bonusEliteHistory,
                                    },
                                  ),
                                  child: Image.asset(icInfoDark),
                                )
                              : GestureDetector(
                                  onTap: () => context.goNamed(
                                    AppRoutes.bonusEliteDetails,
                                    extra: {
                                      'eliteCubit': context.read<EliteCubit>(),
                                      'backScreen': AppRoutes.bonusEliteHistory,
                                    },
                                  ),
                                  child: Image.asset(icInfoWhite),
                                ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Rp ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrDarkBrown : clrWhite,
                      ),
                      children: const [
                        TextSpan(
                          text: '2.000.000',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            // color: clrWhite,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
