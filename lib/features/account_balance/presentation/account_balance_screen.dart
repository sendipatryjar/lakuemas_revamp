import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/bottom_sheet_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/user/domain/entities/balance_entity.dart';
import 'blocs/mutation_onprocess/mutation_onprocess_bloc.dart';
import 'widgets/account_balance_top_widget.dart';
import 'widgets/empty_trx_account_balance_widget.dart';

class AccountBalanceScreen extends StatelessWidget {
  final BalanceEntity? accountBalance;
  const AccountBalanceScreen({super.key, this.accountBalance});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MutationOnprocessBloc>()
        ..add(MutationOnprocessGetEvent(
          helperDataCubit: context.read<HelperDataCubit>(),
        )),
      child: _Content(accountBalance: accountBalance),
    );
  }
}

class _Content extends StatelessWidget {
  final BalanceEntity? accountBalance;
  const _Content({
    Key? key,
    this.accountBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          body: Column(
            children: [
              AccountBalanceTopWidget(
                accountBalance: accountBalance,
                isElite: isElite,
                onBackPressed: () => context.goNamed(AppRoutes.beranda),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            label: t.lblCashWithdrawal,
                            onPressed: () {
                              var kycEntity = context
                                  .read<HelperDataCubit>()
                                  .state
                                  .userDataEntity
                                  ?.kycEntity;
                              var kycStatusKtp =
                                  kycEntity?.objectKyc?['ktp']?.status == 1;
                              var kycStatusAccNumber = kycEntity
                                      ?.objectKyc?['account_number']?.status ==
                                  1;

                              if (kycStatusKtp && kycStatusAccNumber) {
                                context.goNamed(
                                  AppRoutes.cashWithdrawal,
                                  extra: {
                                    'isElite': isElite.toString(),
                                    'accountBalanceEntity': accountBalance
                                  },
                                );
                              } else {
                                BottomSheetUtils.verification(
                                  context: context,
                                  words: wordingKyc(
                                      kycStatusKtp, kycStatusAccNumber),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 76),
                        BlocBuilder<MutationOnprocessBloc,
                            MutationOnprocessState>(
                          builder: (context, state) {
                            if (state is MutationOnprocessLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state is MutationOnprocessSuccessState) {
                              if (state.mutation.isEmpty) {
                                return EmptyTrxAccountBalanceWidget(
                                  isElite: isElite,
                                );
                              }
                              return ListView.builder(
                                itemCount: state.mutation.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      state.mutation[index].code ?? '-',
                                      textScaler: TextScaler.linear(
                                          TextUtils.textScaleFactor(context)),
                                    ),
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
              )
            ],
          ),
        );
      },
    );
  }
}

String wordingKyc(bool statusKycKtp, bool statusKycAccNumber) {
  if (statusKycKtp == false && statusKycAccNumber == false) {
    return 'Ayo lakukan verifikasi KTP, Foto Selfi dan Data Rekening Bank kamu untuk dapat mencairkan saldo akun ke rekeningmu';
  } else if (statusKycKtp == false) {
    return 'Ayo lakukan verifikasi KTP dan Foto Selfi kamu untuk dapat mencairkan saldo akun ke rekeningmu';
  } else if (statusKycAccNumber == false) {
    return 'Ayo lakukan verifikasi Data Rekening Bank kamu untuk dapat mencairkan saldo akun ke rekeningmu';
  } else {
    return 'Ayo lakukan verifikasi KTP, Foto Selfi dan Data Rekening Bank kamu untuk dapat mencairkan saldo akun ke rekeningmu';
  }
}
