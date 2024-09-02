import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/widgets/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../payment/presentation/cubits/payment/payment_cubit.dart';

class PhysicalTradeDetailPayment extends StatelessWidget {
  const PhysicalTradeDetailPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PaymentCubit>()),
      ],
      child: const _Content(),
    );
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
          appBar: _appBar(context, t: t),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: t.lblContinue,
              onPressed: () {
                context.goNamed(
                  AppRoutes.ptWithdrawalMethod,
                  extra: {'isElite': isElite.toString()},
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _detailPayment(
                    context,
                    isElite: isElite,
                    t: t,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: isElite
                          ? clrGreyE5e.withOpacity(0.12)
                          : clrGreyE5e.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 2,
                        color: clrNeutralGrey999.withOpacity(0.16),
                      ),
                    ),
                    child: Column(
                      children: [
                        _switchPayment(
                          title: t.lblUseAccountBalance,
                          subTitle: 'Rp 922.000',
                          isElite: isElite,
                          value: true,
                        ),
                        Divider(
                          thickness: 1,
                          color: clrNeutralGrey999.withOpacity(0.16),
                          height: 32,
                        ),
                        _switchPayment(
                          title: t.lblUseGoldBalance,
                          subTitle: '2,0000 gram',
                          isElite: isElite,
                          value: true,
                        ),
                      ],
                    ),
                  ),
                  _paymentMethodSection(context, isElite: isElite, t: t),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(
    BuildContext context, {
    required AppLocalizations t,
  }) {
    return AppBar(
      backgroundColor: clrBlack101,
      centerTitle: true,
      title: Text(
        '${t.lblSelect} ${t.lblTypePayment}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: MainBackButton(
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  Widget _detailPayment(
    BuildContext context, {
    bool isElite = false,
    required AppLocalizations t,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.lblPaymentDetail,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
            color: isElite
                ? clrGreyE5e.withOpacity(0.12)
                : clrGreyE5e.withOpacity(0.25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              _amoutWidget(
                title: '${t.lblTotal} ${t.lblPrice} ${t.lblGold}',
                total: '5.000.000',
                isElite: isElite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                  height: 32,
                ),
              ),
              _amoutWidget(
                title: t.lblAccountBalance,
                total: '922.000',
                isElite: isElite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                  height: 32,
                ),
              ),
              _amoutWidget(
                title: '${t.lblGoldBalance} (2,000 gr)',
                total: '2.000.000',
                isElite: isElite,
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: clrYellow.withOpacity(0.50),
                ),
                child: _amoutWidget(
                  title: t.lblTotalPayment,
                  total: '2.078.000',
                  isTotal: true,
                  isElite: isElite,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _switchPayment({
    required String title,
    required String subTitle,
    required bool value,
    required bool isElite,
    Function(bool)? onSwitchChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isElite
                          ? clrWhite.withOpacity(0.5)
                          : clrBackgroundBlack.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              value: value,
              activeColor: clrYellow,
              onChanged: onSwitchChanged,
            ),
          ],
        ),
      ],
    );
  }

  Widget _paymentMethodSection(
    BuildContext context, {
    required bool isElite,
    required AppLocalizations t,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.lblPaymentMethods,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            context.goNamed(
              AppRoutes.paymentMethod,
              extra: {
                'isElite': isElite.toString(),
                'backScreen': AppRoutes.physicalTradeDetailPayment,
                'paymentCubit': context.read<PaymentCubit>(),
                // 'physicalPullCheckoutReq': physicalPullCheckoutReq,
                // 'checkout': chargeEntity,
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 2,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
              color: isElite
                  ? clrGreyE5e.withOpacity(0.12)
                  : clrGreyE5e.withOpacity(0.25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${t.lblSelect} ${t.lblPaymentMethods}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isElite
                        ? clrWhite.withOpacity(0.75)
                        : clrBackgroundBlack.withOpacity(0.75),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isElite
                      ? clrWhite.withOpacity(0.32)
                      : clrBackgroundBlack.withOpacity(0.32),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _amoutWidget({
    required String title,
    required String total,
    bool isElite = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
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
                  text: total,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
