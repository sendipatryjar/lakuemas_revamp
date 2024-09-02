import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../domain/entities/laku_trade_qr_data_entity.dart';
import 'blocs/laku_trade_checkout/laku_trade_checkout_bloc.dart';

class LakuTradeDetailScreen extends StatelessWidget {
  final LakuTradeQrDataEntity? lakuTradeQrDataEntity;
  final bool? isValidated;
  const LakuTradeDetailScreen(
      {super.key, this.lakuTradeQrDataEntity, this.isValidated = false});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) {
        if (isValidated == true) {
          return sl<LakuTradeCheckoutBloc>()
            ..add(LakuTradeCheckoutNowEvent(lakuTradeQrDataEntity?.qrCode));
        }
        return sl<LakuTradeCheckoutBloc>();
      },
      child: BlocListener<LakuTradeCheckoutBloc, LakuTradeCheckoutState>(
        listener: (context, state) {
          if (state is LakuTradeCheckoutLoadingState) {
            EasyLoading.show();
          }
          if (state is LakuTradeCheckoutSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.paymentWaiting,
              extra: {
                'isElite': context.read<EliteCubit>().state.toString(),
                'eliteCubit': context.read<EliteCubit>(),
                'transactionCode': state.data?.transactionCode,
              },
            );
          }
          if (state is LakuTradeCheckoutFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(
          key: key,
          lakuTradeQrDataEntity: lakuTradeQrDataEntity,
          isValidated: isValidated,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final LakuTradeQrDataEntity? lakuTradeQrDataEntity;
  final bool? isValidated;
  const _Content({
    Key? key,
    this.lakuTradeQrDataEntity,
    this.isValidated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
            backgroundColor: clrBlack040,
            centerTitle: true,
            title: Text(
              'Laku ${t.lblTrade}',
              // _titleAppbar(t, cameraOverlayFor),
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
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: t.lblTrade,
              onPressed: () {
                context.goNamed(
                  AppRoutes.pin,
                  extra: {
                    'pinType': '${PinType.validate}',
                    'backScreenPin': AppRoutes.lakuTradeDetail,
                    'nextScreenPin': AppRoutes.lakuTradeDetail,
                    'eliteCubit': context.read<EliteCubit>(),
                    'lakuTradeQrDataEntity': lakuTradeQrDataEntity,
                    // 'paymentCubit': context.read<PaymentCubit>(),
                    // 'checkout':
                    //     context.read<PaymentCubit>().state.checkoutEntity
                  },
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Detail Penukaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrDarkBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _detailTransfer(
                    t,
                    isElite,
                    contents: [
                      _labelWidget(
                        title: 'Nama Toko',
                        subTitle: '${lakuTradeQrDataEntity?.storeEntity?.name}',
                        isElite: isElite,
                      ),
                      Divider(
                        color: clrNeutralGrey999.withOpacity(0.16),
                        height: 37,
                      ),
                      _labelWidget(
                        title: t.lblAmountGram,
                        amount: lakuTradeQrDataEntity?.paymentEntity?.gold
                                ?.split(' ')[0] ??
                            '',
                        currency: 'gram',
                        isElite: isElite,
                      ),
                      const SizedBox(height: 22),
                      // Divider(
                      //   color: clrNeutralGrey999.withOpacity(0.16),
                      //   height: 33,
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 20),
                      //   decoration: BoxDecoration(
                      //     color: clrYellow.withOpacity(0.5),
                      //     borderRadius: const BorderRadius.vertical(
                      //         bottom: Radius.circular(30)),
                      //   ),
                      //   child: _labelWidget(
                      //     title: 'Total Penukaran',
                      //     amount: lakuTradeQrDataEntity?.paymentEntity?.total
                      //             ?.split(' ')[0] ??
                      //         '',
                      //     currency: 'gram',
                      //     isElite: isElite,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailTransfer(
    AppLocalizations t,
    bool isElite, {
    List<Widget> contents = const [],
  }) =>
      Container(
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: isElite
              ? clrGreyE5e.withOpacity(0.12)
              : clrGreyE5e.withOpacity(0.25),
          border: Border.all(color: clrNeutralGrey999.withOpacity(0.16)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...contents,
          ],
        ),
      );

  Widget _labelWidget({
    String? title,
    String? subTitle,
    String? amount,
    String? currency,
    bool isElite = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title ?? '-',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              if ((subTitle ?? '').isEmpty && (amount ?? '').isNotEmpty)
                RichText(
                  text: TextSpan(
                    text: amount ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                    children: [
                      TextSpan(
                        text: ' $currency',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if ((subTitle ?? '').isNotEmpty) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subTitle ?? '-',
                  style: TextStyle(
                    fontSize: 12,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                if ((amount ?? '').isNotEmpty)
                  RichText(
                    text: TextSpan(
                      text: amount ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                      children: [
                        TextSpan(
                          text: ' $currency',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ]
      ],
    );
  }
}
