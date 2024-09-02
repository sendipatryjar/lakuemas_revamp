import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../cores/constants/transaction_detail_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/extensions/currency_extension.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/user/domain/entities/balance_entity.dart';
import '../domain/entities/bank_me_entity.dart';
import 'blocs/withdrawal/withdrawal_bloc.dart';
import 'widgets/cash_withdrawal_info_widget.dart';

class CashWithdrawalDetailsScreen extends StatelessWidget {
  final BalanceEntity? accountBalance;
  final double? denom;
  final double? fee;
  final BankMeEntity? bankMeEntity;
  final bool? isPinValidated;
  const CashWithdrawalDetailsScreen({
    super.key,
    this.accountBalance,
    this.denom,
    this.fee,
    this.bankMeEntity,
    this.isPinValidated,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) {
        if (isPinValidated == true) {
          return sl<WithdrawalBloc>()..add(WithdrawalNowEvent(denom?.toInt()));
        }
        return sl<WithdrawalBloc>();
      },
      child: BlocListener<WithdrawalBloc, WithdrawalState>(
        listener: (context, state) {
          if (state is WithdrawalLoadingState) {
            EasyLoading.show();
          }
          if (state is WithdrawalSuccessState) {
            context.read<HelperDataCubit>().resetDataAfterTrx();
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.paymentWaiting,
              extra: {
                'eliteCubit': context.read<EliteCubit>(),
                'transactionDetailType': TransactionDetailType.withdrawal,
                'transactionCode': state.withdrawalEntity?.transactionCode,
              },
            );
          }
          if (state is WithdrawalFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(
          accountBalance: accountBalance,
          denom: denom,
          fee: fee,
          bankMeEntity: bankMeEntity,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final BalanceEntity? accountBalance;
  final double? denom;
  final double? fee;
  final BankMeEntity? bankMeEntity;
  const _Content({
    Key? key,
    this.accountBalance,
    this.denom,
    this.fee,
    this.bankMeEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
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
              onPressed: () {
                context.pop();
              },
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: t.lblConfirm,
              onPressed: () {
                context.goNamed(
                  AppRoutes.pin,
                  extra: {
                    'pinType': '${PinType.validate}',
                    'backScreenPin': AppRoutes.cashWithdrawalDetails,
                    'nextScreenPin': AppRoutes.cashWithdrawalDetails,
                    'eliteCubit': context.read<EliteCubit>(),
                    'accountBalanceEntity': accountBalance,
                    'denom': denom,
                    'fee': fee,
                    'bankMeEntity': bankMeEntity,
                  },
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CashWithdrawalInfoWidget(isElite: isElite),
                  const SizedBox(height: 24),
                  _detailCashWithdrawal(context, t, isElite, denom, fee),
                  const SizedBox(height: 40),
                  _bankWithdrawal(
                    context,
                    t: t,
                    isElite: isElite,
                    bankMeEntity: bankMeEntity,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailCashWithdrawal(
    BuildContext context,
    AppLocalizations t,
    bool isElite,
    double? denom,
    double? fee,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.lblCashWithdrawalDetails,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isElite ? clrWhite : clrDarkBlue,
            ),
          ),
          const SizedBox(height: 16),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.lblCashWithdrawalAmount,
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
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                          children: [
                            TextSpan(
                              text: ' ${denom?.toIdr() ?? '-'}',
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    thickness: 1,
                    height: 33,
                    color: clrNeutralGrey999.withOpacity(0.16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.lblFee,
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
                          text: 'Rp ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                          children: [
                            TextSpan(
                              text: ' ${fee?.toIdr() ?? '-'}',
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
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
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
                        t.lblEarnedTotal,
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
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                          children: [
                            TextSpan(
                              text: ' ${((denom ?? 0) - (fee ?? 0)).toIdr()}',
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
                ),
              ],
            ),
          ),
        ],
      );

  Column _bankWithdrawal(
    BuildContext context, {
    required AppLocalizations t,
    required bool isElite,
    required BankMeEntity? bankMeEntity,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.lblCashWithdrawalDetails,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrDarkBlue,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isElite
                ? clrGreyE5e.withOpacity(0.12)
                : clrGreyE5e.withOpacity(0.25),
            border: Border.all(
              width: 2,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Image.network(
                        bankMeEntity?.logo ?? '',
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Text('no image'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      bankMeEntity?.name ?? '-',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
              ),
              Text(
                '${bankMeEntity?.accountName ?? ''} - ${bankMeEntity?.accountNumber ?? ''}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
