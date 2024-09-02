import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/widgets/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'widgets/physical_trade_card.dart';

class PhysicalTradeScreen extends StatelessWidget {
  const PhysicalTradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: _appBar(context, isElite: isElite, t: t),
          bottomNavigationBar: Container(
            constraints: const BoxConstraints(maxHeight: 108),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(30),
                right: Radius.circular(30),
              ),
              color: isElite ? clrBlack080 : clrWhite,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${t.lblTotal} ${t.lblPrice}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Rp ',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                              children: [
                                TextSpan(
                                  text: '5.000.000',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isElite ? clrWhite : clrBackgroundBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${t.lblTotal} ${t.lblGram}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                          Text(
                            '5,0000',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 138,
                  child: MainButton(
                    label: t.lblContinue,
                    onPressed: () {
                      context.goNamed(
                        AppRoutes.physicalTradeDetailPayment,
                        extra: {'isElite': isElite.toString()},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: List.generate(
                  5,
                  (index) => PhysicalTradeCard(
                    isElite: isElite,
                    stock: 1,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(
    BuildContext context, {
    required bool isElite,
    required AppLocalizations t,
  }) {
    return AppBar(
      backgroundColor: clrBlack101,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t.lblPhysicalTrade,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              context.goNamed(
                AppRoutes.physicalTradeFaq,
                extra: {'isElite': isElite.toString()},
              );
            },
            child: Image.asset(icInfoWhite, width: 16),
          ),
        ],
      ),
      leading: MainBackButton(
        onPressed: () {
          context.goNamed(AppRoutes.beranda);
        },
      ),
      actions: const [
        SizedBox(
          width: 24,
          height: 24,
        ),
      ],
    );
  }
}
