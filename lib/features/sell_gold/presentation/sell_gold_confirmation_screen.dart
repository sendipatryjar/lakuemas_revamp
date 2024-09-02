import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/transaction/domain/entities/checkout_entity.dart';
import 'blocs/sell_gold_checkout_confirm/sell_gold_checkout_confirm_bloc.dart';
import 'widgets/sell_gold_info_widget.dart';

class SellGoldConfirmationScreen extends StatelessWidget {
  final CheckoutEntity? checkoutEntity;
  final bool isValidated;
  const SellGoldConfirmationScreen(
      {super.key, this.checkoutEntity, this.isValidated = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) {
        if (isValidated) {
          return sl<SellGoldCheckoutConfirmBloc>()
            ..add(SellGoldCheckoutConfirmNowEvent(
              checkoutEntity?.transactionKey ?? '',
            ));
        }
        return sl<SellGoldCheckoutConfirmBloc>();
      },
      child: BlocListener<SellGoldCheckoutConfirmBloc,
          SellGoldCheckoutConfirmState>(
        listener: (context, state) {
          if (state is SellGoldCheckoutConfirmLoadingState) {
            EasyLoading.show();
            appPrint('checkout final...');
          }
          if (state is SellGoldCheckoutConfirmSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.paymentWaiting,
              extra: {
                'eliteCubit': context.read<EliteCubit>(),
                'transactionCode': state.checkoutConfirmEntity?.transactionCode,
              },
            );
          }
          if (state is SellGoldCheckoutConfirmFailureState) {
            EasyLoading.dismiss();
            if (state.appFailure is ServerFailure) {
              context.goNamed(
                AppRoutes.serverError,
                extra: {
                  "isElite": context.read<EliteCubit>().state.toString(),
                  "checkout": checkoutEntity,
                  "eliteCubit": context.read<EliteCubit>(),
                  "isValidated": true,
                  "parentScreenName": AppRoutes.sellGoldConfirmation,
                },
              );
              return;
            }
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(t: t, checkoutEntity: checkoutEntity),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.t,
    required this.checkoutEntity,
  }) : super(key: key);

  final AppLocalizations t;
  final CheckoutEntity? checkoutEntity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              '${t.lblSell} ${t.lblGold}',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                // context.goNamed(AppRoutes.sellGold);
                context.pop();
              },
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: t.lblCompleteSales,
              onPressed: () {
                context.goNamed(
                  AppRoutes.pin,
                  extra: {
                    'pinType': '${PinType.validate}',
                    'backScreenPin': AppRoutes.sellGoldConfirmation,
                    'nextScreenPin': AppRoutes.sellGoldConfirmation,
                    'eliteCubit': context.read<EliteCubit>(),
                    // 'paymentCubit': context.read<PaymentCubit>(),
                    'checkout': checkoutEntity,
                  },
                );
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.lblOrderDetails,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : null,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: isElite
                        ? clrGreyE5e.withOpacity(0.12)
                        : clrGreyE5e.withOpacity(0.25),
                    border: Border.all(
                        color: (isElite ? clrWhite : clrNeutralGrey999)
                            .withOpacity(0.16)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      _amountWidget(
                        context,
                        titleWidget: RichText(
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          text: TextSpan(
                              text: checkoutEntity?.goldAmount ?? '-',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                              children: [
                                const TextSpan(
                                    text: ' gr',
                                    style: TextStyle(fontSize: 10)),
                                const TextSpan(
                                    text: ' x', style: TextStyle(fontSize: 14)),
                                const TextSpan(
                                    text: ' Rp',
                                    style: TextStyle(fontSize: 10)),
                                TextSpan(
                                    text:
                                        ' ${checkoutEntity?.goldPrice?.toIdr() ?? '-'}'),
                              ]),
                        ),
                        amount: checkoutEntity?.amount?.toIdr() ?? '-',
                        isElite: isElite,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: clrYellow.withOpacity(0.5),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.lblTotalPayment,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                            RichText(
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              text: TextSpan(
                                  text: 'Rp',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isElite ? clrWhite : clrBackgroundBlack,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          ' ${checkoutEntity?.grossAmount?.toIdr() ?? '-'}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SellGoldInfoWidget(isElite: isElite),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _amountWidget(BuildContext context,
      {String? title,
      Widget? titleWidget,
      String? amount,
      bool isElite = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title != null
              ? Expanded(
                  child: Text(
                    title,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: (titleWidget ?? const SizedBox()),
                ),
          RichText(
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            text: TextSpan(
                text: 'Rp',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
                children: [
                  TextSpan(
                    text: ' ${(amount ?? '')}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
