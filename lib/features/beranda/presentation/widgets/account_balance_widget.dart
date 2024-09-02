import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../cores/utils/bottom_sheet_utils.dart';
import '../../../../cores/utils/text_utils.dart';
import '../blocs/balance/balance_bloc.dart';

class AccountBalanceWidget extends StatelessWidget {
  final bool isElite;
  const AccountBalanceWidget({
    Key? key,
    this.isElite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        // vertical: 15,
      ),
      decoration: BoxDecoration(
        color: isElite ? clrBlack191 : clrWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: isElite ? clrWhite.withOpacity(0.2) : Colors.grey,
            offset: const Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                BerandaBalancesSuccessState? bBalanceScsState;
                if (context.read<BerandaBalancesBloc>().state
                    is BerandaBalancesSuccessState) {
                  bBalanceScsState = context.read<BerandaBalancesBloc>().state
                      as BerandaBalancesSuccessState;
                }
                context.goNamed(
                  AppRoutes.accountBalance,
                  extra: {
                    'isElite': isElite.toString(),
                    'accountBalanceEntity':
                        bBalanceScsState?.accountBalanceEntity
                  },
                );
              },
              child: _AccBalance(isElite: isElite),
            ),
          ),
          VerticalDivider(
            color: isElite ? clrWhiteFef : clrBackgroundBlack,
            width: 32,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(child: _LakuSave(isElite: isElite)),
          VerticalDivider(
            color: isElite ? clrWhiteFef : clrBackgroundBlack,
            width: 32,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                context.goNamed(
                  AppRoutes.elite,
                );
              },
              child: _BonusElite(isElite: isElite),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccBalance extends StatelessWidget {
  const _AccBalance({
    Key? key,
    required this.isElite,
  }) : super(key: key);

  final bool isElite;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.lblAccountBalance,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isElite ? clrYellow : clrNavyBlue,
          ),
        ),
        const SizedBox(height: 2),
        BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
          builder: (context, state) {
            double? accBalance;
            if (state is BerandaBalancesSuccessState) {
              accBalance = state.accountBalanceEntity?.nominalBalance;
            }
            return RichText(
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              text: TextSpan(
                text: 'Rp',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrYellow2 : clrBackgroundBlack,
                ),
                children: [
                  TextSpan(
                      text: ' ${accBalance?.toIdr(isShorten: true) ?? '-'}',
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _LakuSave extends StatelessWidget {
  const _LakuSave({
    Key? key,
    required this.isElite,
  }) : super(key: key);

  final bool isElite;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        var kycEntity =
            context.read<HelperDataCubit>().state.userDataEntity?.kycEntity;
        var kycStatusKtp = kycEntity?.objectKyc?['ktp']?.status == 1;
        var kycStatusNpwp = kycEntity?.objectKyc?['npwp']?.status == 1;

        if (kycStatusKtp && kycStatusNpwp) {
          context.goNamed(
            AppRoutes.lakuSave,
            extra: {
              'isElite': isElite.toString(),
              'berandaBalancesBloc': context.read<BerandaBalancesBloc>()
            },
          );
        } else {
          BottomSheetUtils.verification(
            context: context,
            words: wordingKyc(kycStatusKtp, kycStatusNpwp),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            t.lblLakuSave,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isElite ? clrYellow : clrNavyBlue,
            ),
          ),
          const SizedBox(height: 2),
          BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
            builder: (context, state) {
              double? lakusaveBalance;
              if (state is BerandaBalancesSuccessState) {
                lakusaveBalance = state.lakusaveBalance;
              }
              return RichText(
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                text: TextSpan(
                  text: lakusaveBalance?.toGold4Dec() ?? '-',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isElite ? clrYellow2 : clrBackgroundBlack,
                  ),
                  children: const [
                    TextSpan(
                        text: ' gr',
                        style: TextStyle(
                          fontSize: 8,
                        )),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BonusElite extends StatelessWidget {
  const _BonusElite({
    Key? key,
    required this.isElite,
  }) : super(key: key);

  final bool isElite;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          t.lblEliteBonuses,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isElite ? clrYellow : clrNavyBlue,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          text: TextSpan(
            text: '0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isElite ? clrYellow2 : clrBackgroundBlack,
            ),
          ),
        ),
      ],
    );
  }
}

String wordingKyc(bool statusKycKtp, bool statusKycNpwp) {
  if (statusKycKtp == false && statusKycNpwp == false) {
    return 'Ayo lakukan verifikasi KTP, Foto Selfi dan NPWP untuk dapat akses menu Laku Simpan';
  } else if (statusKycKtp == false) {
    return 'Ayo lakukan verifikasi KTP dan Foto Selfi untuk dapat akses menu Laku Simpan';
  } else if (statusKycNpwp == false) {
    return 'Ayo lakukan verifikasi NPWP untuk dapat akses menu Laku Simpan';
  } else {
    return 'Ayo lakukan verifikasi KTP, Foto Selfi dan NPWP untuk dapat akses menu Laku Simpan';
  }
}
