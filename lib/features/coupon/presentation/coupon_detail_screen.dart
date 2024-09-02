import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../payment/presentation/cubits/payment/payment_cubit.dart';
import '../domain/entities/coupon_detail_entity.dart';
import 'blocs/coupon_validation/coupon_validation_bloc.dart';

class CouponDetailScreen extends StatelessWidget {
  final CouponDetailEntity couponDetailEntity;
  final bool isFromPayment;
  const CouponDetailScreen(
      {super.key, required this.couponDetailEntity, this.isFromPayment = true});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CouponValidationBloc>(),
        ),
      ],
      child: BlocListener<CouponValidationBloc, CouponValidationState>(
        listener: (context, state) {
          if (state is CouponValidationLoadingState) {
            EasyLoading.show();
          }
          if (state is CouponValidationSuccessState) {
            if (state.isValid == true) {
              context.read<PaymentCubit>().changeCoupon(
                    isValid: state.isValid,
                    couponDetailEntity: couponDetailEntity,
                    couponErrMessage: null,
                  );
              EasyLoading.dismiss();
              context.goNamed(
                AppRoutes.paymentConfirmation,
                extra: {
                  'isElite': context.read<EliteCubit>().state.toString(),
                  'eliteCubit': context.read<EliteCubit>(),
                  'paymentCubit': context.read<PaymentCubit>(),
                  'checkout': context.read<PaymentCubit>().state.checkoutEntity,
                },
              );
              return;
            }
            EasyLoading.showInfo(
              'kupon tidak dapat digunakan untuk transaksi ini',
            );
          }
          if (state is CouponValidationFailureState) {
            EasyLoading.dismiss();
            if (state.appFailure is ServerFailure) {
              return;
            }
            List errors = (state.appFailure.errors?.values ?? []).toList();
            String? errorMessage = state.message;
            if (errors.isNotEmpty) {
              errorMessage = errors.join('\n');
            }
            context.read<PaymentCubit>().changeCoupon(
                  isValid:
                      true, // set true for showing coupon on payment confirmation
                  couponDetailEntity: couponDetailEntity,
                  couponErrMessage: errorMessage,
                );
            EasyLoading.showToast(
              errorMessage ?? t.lblSomethingWrong,
              toastPosition: EasyLoadingToastPosition.bottom,
            );
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.paymentConfirmation,
              extra: {
                'isElite': context.read<EliteCubit>().state.toString(),
                'eliteCubit': context.read<EliteCubit>(),
                'paymentCubit': context.read<PaymentCubit>(),
                'checkout': context.read<PaymentCubit>().state.checkoutEntity,
              },
            );
          }
        },
        child: _Content(
          t: t,
          couponDetailEntity: couponDetailEntity,
          isFromPayment: isFromPayment,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  final CouponDetailEntity couponDetailEntity;
  final bool isFromPayment;
  const _Content({
    Key? key,
    required this.t,
    required this.couponDetailEntity,
    this.isFromPayment = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocBuilder<CouponValidationBloc, CouponValidationState>(
          builder: (context, state) {
            if (state is CouponValidationFailureState) {
              if (state.appFailure is ServerFailure) {
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
                  body: ServerErrorScreen(
                    onTryAgainPressed: () {
                      if (isFromPayment) {
                        var amountStr = context
                            .read<PaymentCubit>()
                            .state
                            .checkoutEntity
                            ?.amount;
                        var amount = double.parse(amountStr ?? '0').toInt();
                        context
                            .read<CouponValidationBloc>()
                            .add(CouponValidationTriggerEvent(
                              couponCode: couponDetailEntity.couponCode ?? '',
                              amount: amount,
                              paymentMethodId: context
                                      .read<PaymentCubit>()
                                      .state
                                      .paymentMethodSelected ??
                                  0,
                            ));
                        return;
                      }
                      context.goNamed(
                        AppRoutes.buyGold,
                        extra: {
                          'isElite': isElite.toString(),
                          'couponDetailEntity': couponDetailEntity,
                          'backScreenBuyGold': AppRoutes.couponDetail,
                          'extra': {
                            'isElite': isElite.toString(),
                            'couponDetailEntity': couponDetailEntity,
                            'backScreenBuyGold': AppRoutes.couponDetail,
                            'eliteCubit': context.read<EliteCubit>(),
                            'paymentCubit': context.read<PaymentCubit>(),
                          }
                        },
                      );
                    },
                  ),
                );
              }
            }
            return Scaffold(
              backgroundColor: isElite ? clrBlack080 : null,
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20),
                child: MainButton(
                  label: t.lblUseThisCoupon,
                  onPressed: () {
                    if (isFromPayment) {
                      var amountStr = context
                          .read<PaymentCubit>()
                          .state
                          .checkoutEntity
                          ?.amount;
                      var amount = double.parse(amountStr ?? '0').toInt();
                      context
                          .read<CouponValidationBloc>()
                          .add(CouponValidationTriggerEvent(
                            couponCode: couponDetailEntity.couponCode ?? '',
                            amount: amount,
                            paymentMethodId: context
                                    .read<PaymentCubit>()
                                    .state
                                    .paymentMethodSelected ??
                                0,
                          ));
                      return;
                    }
                    context.goNamed(
                      AppRoutes.buyGold,
                      extra: {
                        'isElite': isElite.toString(),
                        'couponDetailEntity': couponDetailEntity,
                        'backScreenBuyGold': AppRoutes.couponDetail,
                        'extra': {
                          'isElite': isElite.toString(),
                          'couponDetailEntity': couponDetailEntity,
                          'backScreenBuyGold': AppRoutes.couponDetail,
                          'eliteCubit': context.read<EliteCubit>(),
                          'paymentCubit': context.read<PaymentCubit>(),
                        }
                      },
                    );
                  },
                ),
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: 192,
                    child: Stack(
                      children: [
                        Container(
                          height: 192,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: clrYellow,
                          ),
                          child: Image.network(
                            couponDetailEntity.imageUrl ?? '',
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Text(
                                '\n\nno image',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: MainBackButton(
                            color: clrWhite,
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            Text(
                              couponDetailEntity.couponName ?? '-',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrDarkBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${t.lblValidUntil} ${couponDetailEntity.expiredDate.toDateStr()}',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: (isElite ? clrWhite : clrBackgroundBlack)
                                    .withOpacity(0.75),
                              ),
                            ),
                            const Divider(height: 33),
                            Text(
                              couponDetailEntity.description ?? '-',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: (isElite ? clrWhite : clrBackgroundBlack)
                                    .withOpacity(0.75),
                              ),
                            ),
                            const Divider(height: 33),
                            Text(
                              couponDetailEntity.tnc ?? '-',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                // fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: (isElite ? clrWhite : clrBackgroundBlack)
                                    .withOpacity(0.75),
                              ),
                            ),
                            // Html(
                            //   data: HtmlParser.parseHTML(promoEntity.content ?? '')
                            //       .text,
                            //   style: {
                            //     "body": Style(
                            //       margin: Margins.zero,
                            //       padding: EdgeInsets.zero,
                            //       color: (isElite ? clrWhite : clrBackgroundBlack)
                            //           .withOpacity(0.75),
                            //     )
                            //   },
                            // ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
