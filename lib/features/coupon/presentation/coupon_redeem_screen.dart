import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../payment/presentation/cubits/payment/payment_cubit.dart';
import 'blocs/coupon/coupon_bloc.dart';
import 'blocs/coupon_detail/coupon_detail_bloc.dart';
import 'widgets/coupon_widget.dart';
import 'widgets/get_bonus_banner_coupon.dart';

class CouponRedeemScreen extends StatelessWidget {
  final String? backScreen;
  const CouponRedeemScreen({
    super.key,
    this.backScreen = AppRoutes.beranda,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CouponBloc>()..add(CouponsGetEvent()),
        ),
        BlocProvider(
          create: (context) => sl<CouponDetailBloc>(),
        ),
      ],
      child: BlocListener<CouponDetailBloc, CouponDetailState>(
        listener: (context, state) {
          if (state is CouponDetailLoadingState) {
            EasyLoading.show();
          }
          if (state is CouponDetailSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.couponDetail,
              extra: {
                'isElite': context.read<EliteCubit>().state.toString(),
                'eliteCubit': context.read<EliteCubit>(),
                'paymentCubit': context.read<PaymentCubit>(),
                'checkout': context.read<PaymentCubit>().state.checkoutEntity,
                'couponDetailEntity': state.couponDetail,
                'backScreen': backScreen,
              },
            );
          }
          if (state is CouponDetailFailureState) {
            EasyLoading.dismiss();
            if (state.appFailure is ServerFailure) {
              return;
            }
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(
          t: t,
          backScreen: backScreen,
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  final String? backScreen;
  const _Content({
    Key? key,
    required this.t,
    this.backScreen = AppRoutes.beranda,
  }) : super(key: key);

  final AppLocalizations t;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final couponTec = TextEditingController();

  void _onBackPressed(BuildContext context) {
    var payCbt = context.read<PaymentCubit>();
    return context.goNamed(widget.backScreen ?? AppRoutes.beranda, extra: {
      'isElite': context.read<EliteCubit>().state.toString(),
      if (widget.backScreen == AppRoutes.paymentConfirmation) ...{
        'eliteCubit': context.read<EliteCubit>(),
        'paymentCubit': payCbt,
        'checkout': payCbt.state.checkoutEntity,
        'backScreen': AppRoutes.buyGold,
        'isBack': true,
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (val) {
        _onBackPressed(context);
      },
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return BlocBuilder<CouponBloc, CouponState>(
            builder: (context, state) {
              if (state is CouponFailureState) {
                if (state.appFailure is ServerFailure) {
                  return Scaffold(
                    backgroundColor: isElite ? clrBlack080 : null,
                    appBar: AppBar(
                      backgroundColor: clrBlack101,
                      title: Text(
                        "Error",
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                      ),
                      centerTitle: true,
                      leading: MainBackButton(
                        onPressed: () {
                          context.goNamed(AppRoutes.beranda);
                        },
                      ),
                    ),
                    body: ServerErrorScreen(
                      onTryAgainPressed: () {
                        context.read<CouponBloc>().add(CouponsGetEvent());
                      },
                    ),
                  );
                }
              }
              return BlocBuilder<CouponDetailBloc, CouponDetailState>(
                builder: (context, state) {
                  if (state is CouponDetailFailureState) {
                    if (state.appFailure is ServerFailure) {
                      return Scaffold(
                        backgroundColor: isElite ? clrBlack080 : null,
                        appBar: AppBar(
                          backgroundColor: clrBlack101,
                          title: Text(
                            "Error",
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                          ),
                          centerTitle: true,
                          leading: MainBackButton(
                            onPressed: () {
                              context
                                  .read<CouponDetailBloc>()
                                  .add(CouponDetailInitEvent());
                            },
                          ),
                        ),
                        body: ServerErrorScreen(
                          onTryAgainPressed: () {
                            context
                                .read<CouponDetailBloc>()
                                .add(CouponDetailGetEvent(couponTec.text));
                          },
                        ),
                      );
                    }
                  }
                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dx > 2000) {
                        _onBackPressed(context);
                      }
                    },
                    child: Scaffold(
                      backgroundColor: isElite ? clrBlack080 : null,
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GetBonusBannerCoupon(
                            onBackBtnPressed: () {
                              _onBackPressed(context);
                            },
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              widget.t.lblEnterCouponCode,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: clrGreyE5e.withOpacity(0.25),
                              border: Border.all(
                                color: clrNeutralGrey999.withOpacity(0.16),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: couponTec,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isElite ? clrWhite : null,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      // contentPadding: EdgeInsets.zero,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 24),
                                      border: InputBorder.none,
                                      hintText: widget.t.lblCouponCode,
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isElite
                                            ? clrNeutralGrey999.withOpacity(0.5)
                                            : clrBackgroundBlack
                                                .withOpacity(0.5),
                                      ),
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: (isElite
                                                ? clrWhite
                                                : clrBackgroundBlack)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^[a-zA-Z0-9]*')),
                                    ],
                                  ),
                                ),
                                MainButton(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 46,
                                    vertical: 18,
                                  ),
                                  label: widget.t.lblCheck,
                                  onPressed: () {
                                    if (couponTec.text.isNotEmpty) {
                                      context.read<CouponDetailBloc>().add(
                                          CouponDetailGetEvent(couponTec.text));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child:
                                          BlocBuilder<CouponBloc, CouponState>(
                                        builder: (context, state) {
                                          if (state is CouponLoadingState) {
                                            return Column(
                                              children: [
                                                const SizedBox(height: 84),
                                                SizedBox(
                                                  height: 64,
                                                  width: 64,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: clrYellow,
                                                    backgroundColor: clrYellow
                                                        .withOpacity(0.15),
                                                    strokeWidth: 6,
                                                  ),
                                                ),
                                                const SizedBox(height: 32),
                                                Text(
                                                  widget.t.lblCheckingCoupon,
                                                  textScaler: TextScaler.linear(
                                                      TextUtils.textScaleFactor(
                                                          context)),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: isElite
                                                        ? clrWhite
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          if (state is CouponSuccessState) {
                                            if (state.coupons.isNotEmpty) {
                                              return Column(children: [
                                                ...state.coupons
                                                    .map((e) => Column(
                                                          children: [
                                                            CouponWidget(
                                                              title:
                                                                  e.couponName ??
                                                                      '-',
                                                              titleColor: isElite
                                                                  ? clrWhite
                                                                  : clrBackgroundBlack,
                                                              subTitle: e
                                                                  .expiredDate
                                                                  .toDateStr(),
                                                              subTitleColor: isElite
                                                                  ? clrWhite
                                                                      .withOpacity(
                                                                          0.75)
                                                                  : clrBlack3e3,
                                                              imageUrl:
                                                                  e.imageUrl,
                                                              onTap: () {
                                                                context
                                                                    .read<
                                                                        CouponDetailBloc>()
                                                                    .add(CouponDetailGetEvent(
                                                                        e.couponCode ??
                                                                            ''));
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 16),
                                                          ],
                                                        ))
                                                    .toList(),
                                                const SizedBox(height: 12),
                                              ]);
                                            }
                                            return Column(
                                              children: [
                                                const SizedBox(height: 52),
                                                Center(
                                                    child: Image.asset(
                                                        imgPeopleEmpty)),
                                                const SizedBox(height: 32),
                                                Text(
                                                  widget.t.lblNoCouponAvailable,
                                                  textScaler: TextScaler.linear(
                                                      TextUtils.textScaleFactor(
                                                          context)),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: isElite
                                                        ? clrWhite
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
