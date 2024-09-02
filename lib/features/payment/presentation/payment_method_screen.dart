import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/expandable_widget/main_expandable_widget.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../physical_pull/data/models/physical_pull_checkout_req.dart';
import '../domain/entities/payment_method_entity.dart';
import 'blocs/account_balance/account_balance_bloc.dart';
import 'blocs/payment_coupon_validation/payment_coupon_validation_bloc.dart';
import 'blocs/payment_method/payment_method_bloc.dart';
import 'cubits/payment/payment_cubit.dart';
import 'widgets/method_widget.dart';

class PaymentMethodScreen extends StatelessWidget {
  final String? backScreen;
  final CheckoutEntity? checkoutEntity;
  final PhysicalPullCheckoutReq? physicalPullCheckoutReq;
  final Map<String, dynamic>? extra;
  const PaymentMethodScreen({
    super.key,
    this.backScreen,
    this.checkoutEntity,
    this.physicalPullCheckoutReq,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final String actionType =
        physicalPullCheckoutReq == null ? 'purchase' : 'cashout_gold';
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PaymentMethodBloc>()
            ..add(PaymentMethodsGetEvent(
              actionType,
              context.read<HelperDataCubit>(),
            )),
        ),
        BlocProvider(
          create: (context) => sl<AccountBalanceBloc>()
            ..add(AccountBalanceGetEvent(
              helperDataCubit: context.read<HelperDataCubit>(),
            )),
        ),
        BlocProvider(
          create: (context) => sl<PaymentCouponValidationBloc>(),
        ),
      ],
      child: BlocListener<PaymentCouponValidationBloc,
          PaymentCouponValidationState>(
        listener: (context, state) {
          if (state is PaymentCouponValidationLoadingState) {
            EasyLoading.show();
          }
          if (state is PaymentCouponValidationSuccessState) {
            if (state.isValid == true) {
              context.read<PaymentCubit>().changeCoupon(
                    isValid: state.isValid,
                    couponDetailEntity:
                        context.read<PaymentCubit>().state.couponDetailEntity,
                    couponErrMessage: null,
                  );
              EasyLoading.dismiss();
              context.goNamed(AppRoutes.paymentConfirmation, extra: {
                'eliteCubit': context.read<EliteCubit>(),
                'paymentCubit': context.read<PaymentCubit>(),
                'checkout': checkoutEntity,
                'backScreen': backScreen,
              });
              return;
            }
            EasyLoading.showInfo(
              'kupon tidak dapat digunakan untuk transaksi ini',
            );
          }
          if (state is PaymentCouponValidationFailureState) {
            List errors = (state.appFailure.errors?.values ?? []).toList();
            String? errorMessage = state.message;
            if (errors.isNotEmpty) {
              errorMessage = errors.join('\n');
            }
            context.read<PaymentCubit>().changeCoupon(
                  isValid:
                      true, // set true for showing coupon on payment confirmation
                  couponDetailEntity:
                      context.read<PaymentCubit>().state.couponDetailEntity,
                  couponErrMessage: errorMessage,
                );
            EasyLoading.showToast(
              errorMessage ?? t.lblSomethingWrong,
              toastPosition: EasyLoadingToastPosition.bottom,
            );
            EasyLoading.dismiss();
            context.goNamed(AppRoutes.paymentConfirmation, extra: {
              'eliteCubit': context.read<EliteCubit>(),
              'paymentCubit': context.read<PaymentCubit>(),
              'checkout': checkoutEntity,
              'backScreen': backScreen,
            });
          }
        },
        child: _Content(
          t: t,
          backScreen: backScreen,
          checkoutEntity: checkoutEntity,
          physicalPullCheckoutReq: physicalPullCheckoutReq,
          extra: extra,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.t,
    required this.backScreen,
    required this.checkoutEntity,
    required this.physicalPullCheckoutReq,
    this.extra,
  }) : super(key: key);

  final AppLocalizations t;
  final String? backScreen;
  final CheckoutEntity? checkoutEntity;
  final PhysicalPullCheckoutReq? physicalPullCheckoutReq;
  final Map<String, dynamic>? extra;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
          builder: (context, state) {
            if (state is PaymentMethodFailureState) {
              return Scaffold(
                backgroundColor: isElite ? clrBlack080 : null,
                appBar: AppBar(
                  backgroundColor: clrBlack101,
                  title: Text(
                    "Error",
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                  ),
                  centerTitle: true,
                  leading: MainBackButton(
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
                body: const ServerErrorScreen(),
              );
            }
            return Scaffold(
              backgroundColor: isElite ? clrBlack080 : null,
              appBar: AppBar(
                backgroundColor: clrBlack101,
                centerTitle: true,
                title: Text(
                  '${t.lblSelect} ${t.lblPaymentMethods}',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: MainBackButton(
                  onPressed: () {
                    context.pop();
                    // context.goNamed(
                    //   backScreen ?? AppRoutes.beranda,
                    //   queryParameters: {'isElite': isElite.toString()},
                    //   extra: extra,
                    // );
                  },
                ),
              ),
              bottomNavigationBar: Container(
                height: 108,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isElite ? clrBlack080 : clrWhite,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          backScreen == AppRoutes.buyGold
                              ? '${t.lblBuy} ${t.lblGold}'
                              : backScreen == AppRoutes.physicalPullPayment
                                  ? 'Total Biaya'
                                  : '${t.lblSell} ${t.lblGold}',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: (isElite ? clrWhite : clrBackgroundBlack)
                                .withOpacity(0.75),
                          ),
                        ),
                        RichText(
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          text: TextSpan(
                            text: 'Rp',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                            children: [
                              TextSpan(
                                text: checkoutEntity?.detail == null
                                    ? ' ${checkoutEntity?.grossAmount?.toIdr() ?? '-'}'
                                    : ' ${checkoutEntity?.grossAmount?.toIdr() ?? '-'}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Pembulatan masuk Saldo Akun',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: (isElite ? clrWhite : clrBackgroundBlack)
                                .withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                    MainButton(
                      label: t.lblNext,
                      onPressed: () {
                        if (context
                                .read<PaymentCubit>()
                                .state
                                .paymentMethodSelected ==
                            null) {
                          appPrint('please select payment method');
                          return;
                        }
                        if (context
                                .read<PaymentCubit>()
                                .state
                                .couponDetailEntity
                                ?.couponCode !=
                            null) {
                          context
                              .read<PaymentCouponValidationBloc>()
                              .add(PaymentCouponValidationTriggerEvent(
                                couponCode: context
                                        .read<PaymentCubit>()
                                        .state
                                        .couponDetailEntity
                                        ?.couponCode ??
                                    '',
                                amount: int.parse(context
                                        .read<PaymentCubit>()
                                        .state
                                        .checkoutEntity
                                        ?.amount ??
                                    '0'),
                                paymentMethodId: context
                                        .read<PaymentCubit>()
                                        .state
                                        .paymentMethodSelected ??
                                    0,
                              ));
                          return;
                        }
                        if (backScreen == AppRoutes.physicalPullPayment) {
                          context.goNamed(
                            AppRoutes.physicalPullPayment,
                            extra: {
                              'isElite': isElite.toString(),
                              'paymentCubit': context.read<PaymentCubit>(),
                              'physicalPullCheckoutReq':
                                  physicalPullCheckoutReq?.copyWith(
                                paymentMethodId: context
                                    .read<PaymentCubit>()
                                    .state
                                    .paymentMethodSelected,
                              ),
                              'checkout': checkoutEntity,
                            },
                          );
                          return;
                        }
                        context.read<PaymentCubit>().resetOvoPhoneNumber();
                        context.read<PaymentCubit>().resetDebet();
                        context.goNamed(
                          AppRoutes.paymentConfirmation,
                          extra: {
                            'isElite': isElite.toString(),
                            'eliteCubit': context.read<EliteCubit>(),
                            'paymentCubit': context.read<PaymentCubit>(),
                            'checkout': checkoutEntity,
                            'backScreen': backScreen,
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.lblUseAccountBalance,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _accountBalanceCard(t, isElite, checkoutEntity),
                      const SizedBox(height: 20),
                      BlocBuilder<PaymentCubit, PaymentCbtState>(
                        builder: (context, paymentState) {
                          final accBalanceState =
                              context.watch<AccountBalanceBloc>().state;
                          int? accBalanceId;
                          if (accBalanceState is AccountBalanceSuccessState) {
                            accBalanceId =
                                accBalanceState.balanceEntity.paymentMethodId;
                          }
                          if (paymentState.paymentMethodSelected ==
                              accBalanceId) {
                            return const SizedBox();
                          }
                          return Text(
                            t.lblOtherMethods,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : null,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
                        builder: (context, state) {
                          if (state is PaymentMethodLoadingState) {
                            return Shimmer.fromColors(
                              baseColor: clrGreyShimmerBase,
                              highlightColor: clrGreyShimmerHighlight,
                              child: Column(
                                children: List.generate(
                                    4,
                                    (index) => Container(
                                          height: 60,
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          decoration: BoxDecoration(
                                            color: clrWhite,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        )),
                              ),
                            );
                          }
                          if (state is PaymentMethodSuccessState) {
                            final vaList = state.paymentMethods
                                .where((element) =>
                                    element.type?.toLowerCase() ==
                                    'Virtual Account'.toLowerCase())
                                .toList();
                            final eMoneyList = state.paymentMethods
                                .where((element) =>
                                    element.type?.toLowerCase() ==
                                    'E-Money'.toLowerCase())
                                .toList();
                            final eWalletList = state.paymentMethods
                                .where((element) =>
                                    element.type?.toLowerCase() ==
                                    'E-Wallet'.toLowerCase())
                                .toList();
                            final offlineList = state.paymentMethods
                                .where((element) =>
                                    element.type?.toLowerCase() ==
                                    'Offline'.toLowerCase())
                                .toList();
                            final lainnyaList = state.paymentMethods
                                .where((element) =>
                                    element.type?.toLowerCase() ==
                                    'Lainnya'.toLowerCase())
                                .toList();
                            final debitOnlineList = state.paymentMethods
                                .where((element) =>
                                    element.type?.toLowerCase() ==
                                    'Debit Online'.toLowerCase())
                                .toList();
                            final qrisList = state.paymentMethods
                                .where((element) =>
                                    element.type?.toLowerCase() ==
                                    'QRIS'.toLowerCase())
                                .toList();
                            return BlocBuilder<PaymentCubit, PaymentCbtState>(
                              builder: (context, paymentState) {
                                final accBalanceState =
                                    context.watch<AccountBalanceBloc>().state;
                                int? accBalanceId;
                                if (accBalanceState
                                    is AccountBalanceSuccessState) {
                                  accBalanceId = accBalanceState
                                      .balanceEntity.paymentMethodId;
                                }
                                if (accBalanceId != null &&
                                    paymentState.paymentMethodSelected ==
                                        accBalanceId) {
                                  return const SizedBox();
                                }
                                return Column(
                                  children: [
                                    if (vaList.isNotEmpty)
                                      MainExpandableWidget(
                                        title: vaList.firstOrNull?.type ??
                                            'Virtual Account',
                                        titleColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        titlePadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 0,
                                        ),
                                        titleBackgroundColor: isElite
                                            ? clrGreyE5e.withOpacity(0.12)
                                            : clrGreyE5e.withOpacity(0.25),
                                        titleBorderRadius:
                                            BorderRadius.circular(30),
                                        titleBorder: Border.all(
                                            color: isElite
                                                ? clrNeutralGrey999
                                                    .withOpacity(0.16)
                                                : clrBackgroundBlack
                                                    .withOpacity(0.08)),
                                        iconColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        childrenPadding:
                                            const EdgeInsets.only(bottom: 8),
                                        children: vaList
                                            .map(
                                              (paymentMethod) => MethodWidget(
                                                imageUrl:
                                                    paymentMethod.imageUrl,
                                                title:
                                                    paymentMethod.name ?? '-',
                                                subTitle:
                                                    'Biaya Layanan Rp ${paymentMethod.nominalServiceFee}',
                                                methodId: paymentMethod.id,
                                                selectedMethodId: paymentState
                                                    .paymentMethodSelected,
                                                isElite: isElite,
                                                onChanged: (value) => context
                                                    .read<PaymentCubit>()
                                                    .changePaymentMethod(
                                                        paymentMethod),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    if (eMoneyList.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      MainExpandableWidget(
                                        title: eMoneyList.firstOrNull?.type ??
                                            'E-Wallet',
                                        titleColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        titlePadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 0,
                                        ),
                                        titleBackgroundColor: isElite
                                            ? clrGreyE5e.withOpacity(0.12)
                                            : clrGreyE5e.withOpacity(0.25),
                                        titleBorderRadius:
                                            BorderRadius.circular(30),
                                        titleBorder: Border.all(
                                            color: isElite
                                                ? clrNeutralGrey999
                                                    .withOpacity(0.16)
                                                : clrBackgroundBlack
                                                    .withOpacity(0.08)),
                                        iconColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        childrenPadding:
                                            const EdgeInsets.only(bottom: 8),
                                        children: eMoneyList
                                            .map(
                                              (paymentMethod) => MethodWidget(
                                                imageUrl:
                                                    paymentMethod.imageUrl,
                                                title:
                                                    paymentMethod.name ?? '-',
                                                subTitle:
                                                    'Biaya Layanan ${paymentMethod.percentageServiceFee}%',
                                                methodId: paymentMethod.id,
                                                selectedMethodId: paymentState
                                                    .paymentMethodSelected,
                                                isElite: isElite,
                                                onChanged: (value) => context
                                                    .read<PaymentCubit>()
                                                    .changePaymentMethod(
                                                        paymentMethod),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                    if (eWalletList.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      MainExpandableWidget(
                                        title: eWalletList.firstOrNull?.type ??
                                            'E-Wallet',
                                        titleColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        titlePadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 0,
                                        ),
                                        titleBackgroundColor: isElite
                                            ? clrGreyE5e.withOpacity(0.12)
                                            : clrGreyE5e.withOpacity(0.25),
                                        titleBorderRadius:
                                            BorderRadius.circular(30),
                                        titleBorder: Border.all(
                                            color: isElite
                                                ? clrNeutralGrey999
                                                    .withOpacity(0.16)
                                                : clrBackgroundBlack
                                                    .withOpacity(0.08)),
                                        iconColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        childrenPadding:
                                            const EdgeInsets.only(bottom: 8),
                                        children: eWalletList
                                            .map(
                                              (paymentMethod) => MethodWidget(
                                                imageUrl:
                                                    paymentMethod.imageUrl,
                                                title:
                                                    paymentMethod.name ?? '-',
                                                subTitle:
                                                    'Biaya Layanan ${paymentMethod.percentageServiceFee}%',
                                                methodId: paymentMethod.id,
                                                selectedMethodId: paymentState
                                                    .paymentMethodSelected,
                                                isElite: isElite,
                                                onChanged: (value) => context
                                                    .read<PaymentCubit>()
                                                    .changePaymentMethod(
                                                        paymentMethod),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                    if (qrisList.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      MainExpandableWidget(
                                        title: qrisList.firstOrNull?.type ??
                                            'QRIS',
                                        titleColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        titlePadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 0,
                                        ),
                                        titleBackgroundColor: isElite
                                            ? clrGreyE5e.withOpacity(0.12)
                                            : clrGreyE5e.withOpacity(0.25),
                                        titleBorderRadius:
                                            BorderRadius.circular(30),
                                        titleBorder: Border.all(
                                            color: isElite
                                                ? clrNeutralGrey999
                                                    .withOpacity(0.16)
                                                : clrBackgroundBlack
                                                    .withOpacity(0.08)),
                                        iconColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        childrenPadding:
                                            const EdgeInsets.only(bottom: 8),
                                        children: qrisList
                                            .map(
                                              (paymentMethod) => MethodWidget(
                                                imageUrl:
                                                    paymentMethod.imageUrl,
                                                title:
                                                    paymentMethod.name ?? '-',
                                                subTitle:
                                                    'Biaya Layanan ${paymentMethod.percentageServiceFee}%',
                                                methodId: paymentMethod.id,
                                                selectedMethodId: paymentState
                                                    .paymentMethodSelected,
                                                isElite: isElite,
                                                onChanged: (value) => context
                                                    .read<PaymentCubit>()
                                                    .changePaymentMethod(
                                                        paymentMethod),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                    if (debitOnlineList.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      MainExpandableWidget(
                                        title:
                                            debitOnlineList.firstOrNull?.type ??
                                                t.lblOthers,
                                        titleColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        titlePadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 0,
                                        ),
                                        titleBackgroundColor: isElite
                                            ? clrGreyE5e.withOpacity(0.12)
                                            : clrGreyE5e.withOpacity(0.25),
                                        titleBorderRadius:
                                            BorderRadius.circular(30),
                                        titleBorder: Border.all(
                                            color: isElite
                                                ? clrNeutralGrey999
                                                    .withOpacity(0.16)
                                                : clrBackgroundBlack
                                                    .withOpacity(0.08)),
                                        iconColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        childrenPadding:
                                            const EdgeInsets.only(bottom: 8),
                                        children: debitOnlineList
                                            .map(
                                              (paymentMethod) => MethodWidget(
                                                imageUrl:
                                                    paymentMethod.imageUrl,
                                                title:
                                                    paymentMethod.name ?? '-',
                                                subTitle:
                                                    'Biaya Layanan ${paymentMethod.percentageServiceFee}%',
                                                methodId: paymentMethod.id,
                                                selectedMethodId: paymentState
                                                    .paymentMethodSelected,
                                                isElite: isElite,
                                                onChanged: (value) => context
                                                    .read<PaymentCubit>()
                                                    .changePaymentMethod(
                                                        paymentMethod),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                    if (lainnyaList.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      MainExpandableWidget(
                                        title: lainnyaList.firstOrNull?.type ??
                                            t.lblOthers,
                                        titleColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        titlePadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 0,
                                        ),
                                        titleBackgroundColor: isElite
                                            ? clrGreyE5e.withOpacity(0.12)
                                            : clrGreyE5e.withOpacity(0.25),
                                        titleBorderRadius:
                                            BorderRadius.circular(30),
                                        titleBorder: Border.all(
                                            color: isElite
                                                ? clrNeutralGrey999
                                                    .withOpacity(0.16)
                                                : clrBackgroundBlack
                                                    .withOpacity(0.08)),
                                        iconColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        childrenPadding:
                                            const EdgeInsets.only(bottom: 8),
                                        children: lainnyaList
                                            .map(
                                              (paymentMethod) => MethodWidget(
                                                imageUrl:
                                                    paymentMethod.imageUrl,
                                                title:
                                                    paymentMethod.name ?? '-',
                                                subTitle:
                                                    'Biaya Layanan ${paymentMethod.percentageServiceFee}%',
                                                methodId: paymentMethod.id,
                                                selectedMethodId: paymentState
                                                    .paymentMethodSelected,
                                                isElite: isElite,
                                                onChanged: (value) => context
                                                    .read<PaymentCubit>()
                                                    .changePaymentMethod(
                                                        paymentMethod),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                    if (offlineList.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      MainExpandableWidget(
                                        title: offlineList.firstOrNull?.type ??
                                            'Offline',
                                        titleColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        titlePadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 0,
                                        ),
                                        titleBackgroundColor: isElite
                                            ? clrGreyE5e.withOpacity(0.12)
                                            : clrGreyE5e.withOpacity(0.25),
                                        titleBorderRadius:
                                            BorderRadius.circular(30),
                                        titleBorder: Border.all(
                                            color: isElite
                                                ? clrNeutralGrey999
                                                    .withOpacity(0.16)
                                                : clrBackgroundBlack
                                                    .withOpacity(0.08)),
                                        iconColor: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                        childrenPadding:
                                            const EdgeInsets.only(bottom: 8),
                                        children: offlineList
                                            .map(
                                              (paymentMethod) => MethodWidget(
                                                imageUrl:
                                                    paymentMethod.imageUrl,
                                                title:
                                                    paymentMethod.name ?? '-',
                                                subTitle:
                                                    'Biaya Layanan Rp ${paymentMethod.nominalServiceFee}',
                                                methodId: paymentMethod.id,
                                                selectedMethodId: paymentState
                                                    .paymentMethodSelected,
                                                isElite: isElite,
                                                onChanged: (value) => context
                                                    .read<PaymentCubit>()
                                                    .changePaymentMethod(
                                                        paymentMethod),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _accountBalanceCard(
    AppLocalizations t,
    bool isElite,
    CheckoutEntity? checkoutEntity,
  ) =>
      BlocBuilder<AccountBalanceBloc, AccountBalanceState>(
        builder: (context, state) {
          if (state is AccountBalanceLoadingState) {
            return Shimmer.fromColors(
              baseColor: clrGreyShimmerBase,
              highlightColor: clrGreyShimmerHighlight,
              child: Container(
                width: double.infinity,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: clrWhite,
                ),
              ),
            );
          }
          int? id;
          double? balance;
          String? name;
          if (state is AccountBalanceSuccessState) {
            id = state.balanceEntity.paymentMethodId;
            name = state.balanceEntity.type?.replaceAll('_', ' ').toUpperCase();
            balance = state.balanceEntity.nominalBalance;
          }
          double grossAmount = double.parse(checkoutEntity?.grossAmount ?? '0');
          bool isBalanceEnough = (balance ?? 0) >= grossAmount;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            decoration: BoxDecoration(
              color: isBalanceEnough
                  ? (isElite
                      ? clrGreyE5e.withOpacity(0.12)
                      : clrGreyE5e.withOpacity(0.25))
                  : clrRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isBalanceEnough
                    ? (isElite
                        ? clrNeutralGrey999.withOpacity(0.16)
                        : clrBackgroundBlack.withOpacity(0.08))
                    : clrRed.withOpacity(0.2),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.lblYouHave,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: (isElite ? clrWhite : clrBackgroundBlack)
                          .withOpacity(0.75),
                    ),
                  ),
                  Text(
                    'Rp ${balance?.toIdr() ?? '-'}',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  if (isBalanceEnough == false)
                    Text(
                      t.lblYourAccountBalanceIsNotEnough,
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: clrRed,
                      ),
                    ),
                ],
              ),
              trailing: BlocBuilder<PaymentCubit, PaymentCbtState>(
                buildWhen: (previous, current) =>
                    previous.paymentMethodSelected !=
                    current.paymentMethodSelected,
                builder: (context, paymentState) {
                  var paymentMethodBloc = context.watch<PaymentMethodBloc>();
                  String? imageUrl;
                  if (paymentMethodBloc.state is PaymentMethodSuccessState) {
                    var paymentMethodEntity =
                        (paymentMethodBloc.state as PaymentMethodSuccessState)
                            .paymentMethods
                            .where((element) => element.id == id)
                            .firstOrNull;
                    imageUrl = paymentMethodEntity?.imageUrl;
                  }
                  return CupertinoSwitch(
                    value: paymentState.paymentMethodSelected == id,
                    activeColor: clrYellow,
                    trackColor: clrNeutralGrey999.withOpacity(0.5),
                    onChanged: isBalanceEnough
                        ? (value) {
                            int? idHelper;
                            if (value) {
                              idHelper = id;
                            }
                            context
                                .read<PaymentCubit>()
                                .changePaymentMethod(PaymentMethodEntity(
                                  id: idHelper,
                                  name: name,
                                  accountBalance: balance,
                                  imageUrl: imageUrl,
                                ));
                          }
                        : null,
                  );
                },
              ),
              onTap: null,
            ),
          );
        },
      );
}
