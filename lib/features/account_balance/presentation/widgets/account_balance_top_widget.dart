import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_back_button.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';

class AccountBalanceTopWidget extends StatelessWidget {
  final BalanceEntity? accountBalance;
  final bool isElite;
  final Function()? onBackPressed;
  const AccountBalanceTopWidget({
    super.key,
    required this.accountBalance,
    required this.isElite,
    this.onBackPressed,
  });

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
              t.lblAccountBalance,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: onBackPressed,
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
                            t.lblMyAccBalance,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrDarkBrown : clrWhite,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => context.goNamed(
                              AppRoutes.accountBalanceFaq,
                              extra: {
                                'isElite': isElite.toString(),
                                'accountBalanceEntity': accountBalance
                              },
                            ),
                            child: isElite
                                ? Image.asset(icInfoDark)
                                : Image.asset(icInfoWhite),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed(
                          AppRoutes.cashWithdrawalHistory,
                          extra: {
                            'isElite': isElite.toString(),
                            'accountBalanceEntity': accountBalance
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
                                t.lblHistory,
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isElite ? clrDarkBrown : clrWhite,
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
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    text: TextSpan(
                      text: 'Rp ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrDarkBrown : clrWhite,
                      ),
                      children: [
                        TextSpan(
                          text: accountBalance?.nominalBalance?.toIdr() ?? '-',
                          style: const TextStyle(
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
