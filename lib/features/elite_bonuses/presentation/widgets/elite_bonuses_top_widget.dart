import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/widgets/main_back_button.dart';

class EliteBonusesTopWidget extends StatelessWidget {
  final bool isElite;
  const EliteBonusesTopWidget({super.key, required this.isElite});

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
              t.lblEliteBonuses,
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
            child: Container(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 24),
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
                                            'eliteCubit':
                                                context.read<EliteCubit>()
                                          },
                                        ),
                                        child: Image.asset(icInfoDark),
                                      )
                                    : GestureDetector(
                                        onTap: () => context.goNamed(
                                          AppRoutes.bonusEliteDetails,
                                          extra: {
                                            'eliteCubit':
                                                context.read<EliteCubit>()
                                          },
                                        ),
                                        child: Image.asset(icInfoWhite),
                                      ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => context.goNamed(
                                AppRoutes.bonusEliteHistory,
                                extra: {
                                  'eliteCubit': context.read<EliteCubit>()
                                },
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: clrNeutralGrey999.withOpacity(0.32),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${t.lblHistory} ${t.lblBonuses}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            isElite ? clrDarkBrown : clrWhite,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    isElite
                                        ? Image.asset(icHistoryDark)
                                        : Container(
                                            width: 16,
                                            height: 16,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(icHistory),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
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
                        const SizedBox(height: 8),
                        Text(
                          t.lblEliteBonusesSumary,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isElite ? clrDarkBrown : clrWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          clrNeutralGrey999.withOpacity(0.12),
                          clrNeutralGrey999.withOpacity(0.06),
                        ],
                      ),
                      border: Border.all(
                        color: clrWhite.withOpacity(0.20),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '0 bonus kamu akan hangus pada -',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrDarkBrown : clrWhite,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            context.goNamed(
                              AppRoutes.bonusEliteExpDetails,
                              extra: {'eliteCubit': context.read<EliteCubit>()},
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                t.lblExpired,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: isElite
                                      ? clrDarkBrown.withOpacity(0.75)
                                      : clrWhite.withOpacity(0.75),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.arrow_right_rounded,
                                size: 18,
                                color: isElite ? clrDarkBrown : clrWhite,
                              ),
                            ],
                          ),
                        ),
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
