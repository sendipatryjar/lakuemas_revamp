import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_card_balance_widget.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../beranda/presentation/blocs/balance/balance_bloc.dart';
import 'blocs/transfer_charge/transfer_charge_bloc.dart';
import 'cubits/transfer/transfer_cubit.dart';
import 'cubits/transfer_validation/transfer_validation_cubit.dart';
import 'widgets/transfer_tab.dart';

class TransferScreen extends StatefulWidget {
  final String? dataQr;
  final String? decodedQr;
  const TransferScreen({super.key, this.dataQr, this.decodedQr});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TransferCubit>()..fillFavorites(),
        ),
        BlocProvider(
          create: (context) => sl<TransferValidationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<TransferChargeBloc>(),
        ),
      ],
      child: BlocListener<TransferChargeBloc, TransferChargeState>(
        listener: (context, state) {
          if (state is TransferChargeLoadingState) {
            EasyLoading.show();
          }
          if (state is TransferChargeSuccessState) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.transferDetails,
              extra: {
                'isElite': context.read<EliteCubit>().state.toString(),
                'transferChargeEntity': state.transferChargeEntity,
                'berandaBalancesBloc': context.read<BerandaBalancesBloc>(),
              },
            );
          }
          if (state is TransferChargeFailureState) {
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
          dataQR: widget.dataQr,
          decodedQr: widget.decodedQr,
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  final String? dataQR;
  final String? decodedQr;
  const _Content({
    Key? key,
    this.dataQR,
    this.decodedQr,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final TextEditingController totalGoldTec = TextEditingController();

  final TextEditingController noRekeningTec = TextEditingController();

  final TextEditingController notesTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final noRekeningQR = widget.dataQR?.split('|');
    final qrFromGallery = widget.decodedQr?.split('|');

    final t = AppLocalizations.of(context)!;

    if (noRekeningQR != null) {
      noRekeningTec.text = noRekeningQR[0];
    } else if (qrFromGallery != null) {
      noRekeningTec.text = qrFromGallery[0];
    }

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocBuilder<TransferChargeBloc, TransferChargeState>(
          builder: (context, state) {
            if (state is TransferChargeFailureState) {
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
                        context.goNamed(AppRoutes.beranda);
                      },
                    ),
                  ),
                  body: ServerErrorScreen(
                    onTryAgainPressed: () {
                      context
                          .read<TransferChargeBloc>()
                          .add(TransferChargeInitEvent());
                    },
                  ),
                );
              }
            }
            return Scaffold(
              backgroundColor: isElite ? clrBlack080 : null,
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20),
                child: BlocBuilder<TransferValidationCubit,
                    TransferValidationState>(
                  builder: (context, state) {
                    var goldBalanceStr = (context
                            .watch<BerandaBalancesBloc>()
                            .state as BerandaBalancesSuccessState)
                        .goldBalanceEntity
                        ?.gramationBalance;
                    return MainButton(
                      label: t.lblContinue,
                      onPressed: () {
                        var noRekFromFav = context
                            .read<TransferCubit>()
                            .state
                            .selectedFavorite
                            ?.accountNumber;
                        context.read<TransferValidationCubit>().validate(
                              t: t,
                              totalGold: totalGoldTec.text,
                              noRekening: noRekeningTec.text,
                              noRekeningFromFav: noRekFromFav,
                              goldBalance:
                                  double.tryParse(goldBalanceStr ?? ''),
                            );

                        final isValid =
                            context.read<TransferValidationCubit>().isValid;
                        if (isValid) {
                          context
                              .read<TransferChargeBloc>()
                              .add(TransferChargeNowEvent(
                                goldWeight: double.parse(totalGoldTec.text),
                                accountNumber:
                                    noRekFromFav ?? noRekeningTec.text,
                                isAddFavorite: context
                                    .read<TransferCubit>()
                                    .state
                                    .isFavorite,
                                note: notesTec.text,
                              ));
                        }
                      },
                    );
                  },
                ),
              ),
              body: Column(
                children: [
                  AppBar(
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
                        context.goNamed(AppRoutes.beranda);
                      },
                    ),
                  ),
                  MainCardBalanceWidget(
                    isElite: isElite,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  t.lblGoldAmount,
                                  textScaler: TextScaler.linear(
                                      TextUtils.textScaleFactor(context)),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: (isElite
                                            ? clrWhite
                                            : clrBackgroundBlack)
                                        .withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: BlocBuilder<BerandaBalancesBloc,
                                      BerandaBalancesState>(
                                    builder: (context, state) {
                                      String goldBalance = '-';
                                      if (state
                                          is BerandaBalancesSuccessState) {
                                        goldBalance = state.goldBalanceEntity
                                                ?.gramationBalance ??
                                            '-';
                                      }
                                      return Text(
                                        'Sisa saldo : $goldBalance gram',
                                        textScaler: TextScaler.linear(
                                            TextUtils.textScaleFactor(context)),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: clrBlue006,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            BlocBuilder<TransferValidationCubit,
                                TransferValidationState>(
                              builder: (context, state) {
                                return MainTextField(
                                  controller: totalGoldTec,
                                  hintText: 'Masukkan Jumlah Gram Emas...',
                                  isDarkMode: isElite,
                                  textInputType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                                  onChange: (p0) {
                                    context
                                        .read<TransferValidationCubit>()
                                        .resetValidateGold();
                                  },
                                  isError: state.isTotalGoldError ?? false,
                                  errorText: state.totalGoldErrorMessages,
                                  textInputFormatter: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d{0,4}')),
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'^\.+'),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '${t.lblSelect} ${t.lblLakuemasAccount}',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: (isElite ? clrWhite : clrBackgroundBlack)
                                    .withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TransferTab(
                              isElite: isElite,
                              noRekeningTec: noRekeningTec,
                            ),
                            const SizedBox(height: 20),
                            MainTextField(
                              controller: notesTec,
                              title: t.lblNews,
                              titleColor:
                                  (isElite ? clrWhite : clrBackgroundBlack)
                                      .withOpacity(0.75),
                              isDarkMode: isElite,
                              hintText: t.lblNewsHint,
                              maxLines: 6,
                              isAddress: true,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z0-9_ ]*')),
                              ],
                            ),
                            const SizedBox(height: 16),
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
