import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../../../features/physical_pull/data/models/physical_pull_checkout_req.dart';

import '../../../../cores/extensions/currency_extension.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/widgets/card_list_widget.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../payment/domain/entities/payment_method_entity.dart';
import '../../payment/presentation/cubits/payment/payment_cubit.dart';
import '../../payment/presentation/widgets/method_widget.dart';
import 'blocs/physical_pull_checkout/physical_pull_checkout_bloc.dart';

class PhysicalPullPaymentScreen extends StatelessWidget {
  final PhysicalPullCheckoutReq? physicalPullCheckoutReq;
  final CheckoutEntity? chargeEntity;
  final bool isValidated;
  const PhysicalPullPaymentScreen({
    super.key,
    this.physicalPullCheckoutReq,
    this.chargeEntity,
    this.isValidated = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final paymentCbtState = context.read<PaymentCubit>().state;
    final request = physicalPullCheckoutReq?.copyWith(
      ovoPhoneNumber: paymentCbtState.ovoPhoneNumber,
    );
    if (isValidated) {
      appPrint('isValidated: $isValidated');
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PhysicalPullCheckoutBloc>()),
        BlocProvider(create: (context) {
          if (isValidated) {
            return sl<PhysicalPullCheckoutBloc>()
              ..add(PhysicalPullCheckoutGetEvent(request));
          }
          return sl<PhysicalPullCheckoutBloc>();
        }),
      ],
      child: BlocListener<PhysicalPullCheckoutBloc, PhysicalPullCheckoutState>(
        listener: (context, state) {
          if (state is PhysicalPullCheckoutLoadingState) {
            EasyLoading.show();
            appPrint('payment loading...');
          }
          if (state is PhysicalPullCheckoutSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.paymentWaiting,
              extra: {
                'eliteCubit': context.read<EliteCubit>(),
                'transactionCode':
                    state.physicalPullCheckoutEntity.transactionCode,
              },
            );
          }
          if (state is PhysicalPullCheckoutFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
            context.goNamed(
              AppRoutes.physicalPullPayment,
              extra: {
                'isElite': context.read<EliteCubit>().state.toString(),
                'paymentCubit': context.read<PaymentCubit>(),
                'physicalPullCheckoutReq': physicalPullCheckoutReq,
                'checkout': chargeEntity,
                'isValidated': false,
              },
            );
          }
        },
        child: _Content(
          physicalPullCheckoutReq: physicalPullCheckoutReq,
          chargeEntity: chargeEntity,
          isValidated: isValidated,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final PhysicalPullCheckoutReq? physicalPullCheckoutReq;
  final CheckoutEntity? chargeEntity;
  final bool isValidated;

  const _Content({
    Key? key,
    this.physicalPullCheckoutReq,
    this.chargeEntity,
    this.isValidated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack101 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblPayment,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.goNamed(
                  AppRoutes.physicalPull,
                  extra: {'isElite': isElite.toString()},
                );
              },
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            // color: clrWhite,
            child: MainButton(
              label: t.lblCompletePayment,
              onPressed: isValidated
                  ? null
                  : physicalPullCheckoutReq?.paymentMethodId == null ||
                          physicalPullCheckoutReq?.deliveryMethod == null
                      ? null
                      : () {
                          var isValidated = formKey.currentState?.validate();
                          appPrint('isValidated: $isValidated');
                          if (isValidated == false) return;
                          appPrint('do action');
                          context.goNamed(
                            AppRoutes.pin,
                            extra: {
                              'pinType': '${PinType.validate}',
                              'backScreenPin': AppRoutes.physicalPullPayment,
                              'nextScreenPin': AppRoutes.physicalPullPayment,
                              'eliteCubit': context.read<EliteCubit>(),
                              'paymentCubit': context.read<PaymentCubit>(),
                              'physicalPullCheckoutReq':
                                  physicalPullCheckoutReq,
                              'checkout': chargeEntity,
                            },
                          );
                        },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.lblWithdrawalMethod,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CardListWidget(
                    isUseDevider: false,
                    isUseRightArrow: true,
                    isElite: isElite,
                    itemLength: 1,
                    title: (_) {
                      return physicalPullCheckoutReq?.destinationAddress != null
                          ? physicalPullCheckoutReq?.destinationAddress ?? '-'
                          : '${t.lblSelect} ${t.lblWithdrawalMethod}';
                    },
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                    onTap: (_) {
                      context.goNamed(
                        AppRoutes.physicalWithdrawalMethod,
                        extra: {
                          'eliteCubit': context.read<EliteCubit>(),
                          'paymentCubit': context.read<PaymentCubit>(),
                          'physicalPullCheckoutReq':
                              physicalPullCheckoutReq?.copyWith(),
                          'checkout': chargeEntity,
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t.lblPaymentMethod,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  physicalPullCheckoutReq?.paymentMethodId != null
                      ? GestureDetector(
                          onTap: () {
                            context.goNamed(
                              AppRoutes.paymentMethod,
                              extra: {
                                'isElite': isElite.toString(),
                                'backScreen': AppRoutes.physicalPullPayment,
                                'paymentCubit': context.read<PaymentCubit>(),
                                'physicalPullCheckoutReq':
                                    physicalPullCheckoutReq,
                                'checkout': chargeEntity,
                              },
                            );
                          },
                          child: _paymentMethodWidget(t, formKey, isElite))
                      : CardListWidget(
                          isUseDevider: false,
                          isUseRightArrow: true,
                          isElite: isElite,
                          itemLength: 1,
                          title: (_) => '${t.lblSelect} ${t.lblPaymentMethod}',
                          titleStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                          onTap: (_) {
                            context.goNamed(
                              AppRoutes.paymentMethod,
                              extra: {
                                'isElite': isElite.toString(),
                                'backScreen': AppRoutes.physicalPullPayment,
                                'paymentCubit': context.read<PaymentCubit>(),
                                'physicalPullCheckoutReq':
                                    physicalPullCheckoutReq,
                                'checkout': chargeEntity,
                              },
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                  Text(
                    t.lblOrderDetails,
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
                    child: BlocBuilder<PaymentCubit, PaymentCbtState>(
                      builder: (context, paymentCbtState) {
                        double pgServiceFee = _serviceFeeOnDetailsOrder(
                          paymentCbtState.paymentMethodEntity,
                          chargeEntity!,
                        ).ceilToDouble();
                        double price =
                            double.tryParse(chargeEntity?.grossAmount ?? '0')!
                                .toDouble();
                        double totalPay = pgServiceFee + price;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Biaya Sertifikat',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isElite ? clrWhite : clrBackgroundBlack,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                chargeEntity!.detail!.length,
                                (index) => _amountWidget(
                                  titleWidget: RichText(
                                    text: TextSpan(
                                      text:
                                          '${chargeEntity?.detail![index].goldBrand} - ${chargeEntity?.detail![index].goldFragment} Gram (${chargeEntity?.detail![index].qty}x)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                      ),
                                    ),
                                  ),
                                  amount: chargeEntity
                                      ?.detail![index].totalCertificateCost
                                      .toIdr(),
                                  isElite: isElite,
                                ),
                              ),
                            ),
                            if (paymentCbtState.paymentMethodEntity != null)
                              const SizedBox(height: 10),
                            if (paymentCbtState.paymentMethodEntity != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Biaya Layanan',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Rp ',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isElite
                                              ? clrWhite
                                              : clrBackgroundBlack,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: pgServiceFee.toIdr(),
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                  bottom: Radius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    t.lblTotalPayment,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isElite
                                          ? clrWhite
                                          : clrBackgroundBlack,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Rp ',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: totalPay.toIdr(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _paymentMethodWidget(
      AppLocalizations t, GlobalKey formKeyy, bool isElite) {
    return BlocBuilder<PaymentCubit, PaymentCbtState>(
      builder: (context, paymentCbtState) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isElite
                ? clrGreyE5e.withOpacity(0.12)
                : clrGreyE5e.withOpacity(0.25),
            border: Border.all(
                color: isElite
                    ? clrNeutralGrey999.withOpacity(0.16)
                    : clrNeutralGrey999.withOpacity(0.16)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MethodWidget(
                contentPadding: const EdgeInsets.all(0),
                imageUrl: paymentCbtState.paymentMethodEntity?.imageUrl,
                title: paymentCbtState.paymentMethodEntity?.name ?? '-',
                subTitle: _serviceFee(paymentCbtState.paymentMethodEntity),
                isElite: isElite,
              ),
              if (paymentCbtState.paymentMethodEntity?.name
                      ?.toLowerCase()
                      .contains('ovo') ??
                  false)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 33),
                    Text(
                      t.lblNumberLinkedTo(
                          paymentCbtState.paymentMethodEntity?.name ?? '-'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Form(
                      key: formKeyy,
                      child: MainTextField(
                        // controller: TextEditingController(text: ''),
                        hintText: t.lblInputYourPhoneNumber,
                        onChange: (value) {
                          context.read<PaymentCubit>().addOvoPhoneNumber(value);
                        },
                        onFieldSubmitted: (_) {},
                        // isError: isError,
                        isDarkMode: isElite,
                        validator: (value) {
                          if ((value ?? '').isEmpty) {
                            return t.lblCantBeEmpty;
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  String _serviceFee(PaymentMethodEntity? paymentMethodEntity) {
    switch (paymentMethodEntity?.type?.toLowerCase()) {
      case 'e-money':
      case 'lainnya':
        return 'Biaya Layanan ${paymentMethodEntity?.percentageServiceFee}%';
      case 'virtual account':
      case 'offline':
        return 'Biaya Layanan Rp ${paymentMethodEntity?.nominalServiceFee?.toIdr() ?? '-'}';
      default:
        return 'Saldo ${paymentMethodEntity?.accountBalance?.toIdr() ?? '0'}';
    }
  }

  double _serviceFeeOnDetailsOrder(
      PaymentMethodEntity? paymentMethodEntity, CheckoutEntity checkoutEntity) {
    switch (paymentMethodEntity?.type?.toLowerCase()) {
      case 'e-money':
      case 'lainnya':
        double total =
            (double.tryParse(checkoutEntity.grossAmount ?? '') ?? 0) +
                (paymentMethodEntity?.nominalServiceFee ?? 0).toDouble();
        double normalServiceFee =
            (paymentMethodEntity?.percentageServiceFee ?? 0) / 100;
        double serviceFee = (total / (1 - normalServiceFee)) - total;
        return serviceFee;
      default:
        return paymentMethodEntity?.nominalServiceFee?.toDouble() ?? 0;
    }
  }

  Widget _amountWidget(
      {String? title,
      Widget? titleWidget,
      String? amount,
      bool isElite = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Biaya Sertifikat',
          //   style: TextStyle(
          //     fontWeight: FontWeight.w500,
          //     color: isElite ? clrWhite : clrBackgroundBlack,
          //   ),
          // ),
          // const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title != null
                  ? Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: (titleWidget ?? const SizedBox()),
                    ),
              RichText(
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
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
