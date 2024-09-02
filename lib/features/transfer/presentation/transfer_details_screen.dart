import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/widgets/main_button.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../beranda/presentation/blocs/balance/balance_bloc.dart';
import '../domain/entities/transfer_charge_entity.dart';
import 'blocs/transfer_checkout/transfer_checkout_bloc.dart';

class TransferDetailsScreen extends StatelessWidget {
  final bool isValidated;
  final TransferChargeEntity transferChargeEntity;

  const TransferDetailsScreen({
    super.key,
    this.isValidated = false,
    required this.transferChargeEntity,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        (isValidated)
            ? BlocProvider(
                create: (context) => sl<TransferCheckoutBloc>()
                  ..add(TransferCheckoutNowEvent(
                      transactionKey:
                          transferChargeEntity.transactionKey ?? '')),
              )
            : BlocProvider(create: (context) => sl<TransferCheckoutBloc>()),
      ],
      child: BlocListener<TransferCheckoutBloc, TransferCheckoutState>(
        listener: (context, state) {
          if (state is TransferCheckoutLoadingState) {
            EasyLoading.show();
          }
          if (state is TransferCheckoutSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.paymentWaiting,
              extra: {
                'eliteCubit': context.read<EliteCubit>(),
                'transactionCode': state.transactionCode,
              },
            );
          }
          if (state is TransferCheckoutFailureState) {
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
        child: BlocBuilder<EliteCubit, bool>(
          builder: (context, isElite) {
            return BlocBuilder<TransferCheckoutBloc, TransferCheckoutState>(
              builder: (context, state) {
                if (state is TransferCheckoutFailureState) {
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
                          context
                              .read<TransferCheckoutBloc>()
                              .add(TransferCheckoutInitEvent());
                        },
                      ),
                    );
                  }
                }
                return Scaffold(
                  backgroundColor: isElite ? clrBlack080 : null,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: clrBlack101,
                    centerTitle: true,
                    title: Text(
                      t.lblTransfer,
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
                      },
                    ),
                  ),
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.all(20),
                    child: MainButton(
                      label: t.lblSend,
                      onPressed: () {
                        context.goNamed(
                          AppRoutes.pin,
                          extra: {
                            'pinType': '${PinType.validate}',
                            'backScreenPin': AppRoutes.transferDetails,
                            'nextScreenPin': AppRoutes.transferDetails,
                            'eliteCubit': context.read<EliteCubit>(),
                            'transferChargeEntity': transferChargeEntity,
                            'berandaBalancesBloc':
                                context.read<BerandaBalancesBloc>(),
                            // 'TransferCheckoutCubit': context.read<TransferCheckoutCubit>(),
                            // 'checkout':
                            //     context.read<TransferCheckoutCubit>().state.checkoutEntity
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
                          const SizedBox(height: 12),
                          Text(
                            t.lblDetailsTransfer,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _detailTransfer(context, t, isElite),
                          const SizedBox(height: 16),
                          _transferWarningWidget(context, t, isElite),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _detailTransfer(
          BuildContext context, AppLocalizations t, bool isElite) =>
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailsTransferWidget(
              context,
              title: t.lblDestination,
              subTitle: transferChargeEntity.accountName,
              isElite: isElite,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
                height: 33,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            _detailsTransferWidget(
              context,
              title: t.lblAccountNumber,
              subTitle: transferChargeEntity.accountNumber,
              isElite: isElite,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: clrYellow.withOpacity(0.5),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.lblTotalTransfer,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  RichText(
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    text: TextSpan(
                      text: transferChargeEntity.goldWeight,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                      children: [
                        TextSpan(
                          text: ' gram',
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
          ],
        ),
      );

  Widget _detailsTransferWidget(BuildContext context,
      {String? title, String? subTitle, bool isElite = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '-',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 12,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subTitle ?? '-',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _transferWarningWidget(
      BuildContext context, AppLocalizations t, bool isElite) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: clrYellow.withOpacity(0.16)),
      child: Row(
        children: [
          Image.asset(icWarningOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.lblTransferWarning,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
