import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/errors/app_failure.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/input_formater/uppercase_input_formater.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/get_bonus_banner.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../beranda/presentation/blocs/price_setting/price_setting_bloc.dart';
import 'blocs/redeem/redeem_bloc.dart';
import 'blocs/redeem_check/redeem_check_bloc.dart';
import 'widgets/regular_information_widget.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  final codeRedeemTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<RedeemCheckBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<RedeemBloc>(),
        ),
      ],
      child: BlocListener<RedeemBloc, RedeemState>(
        listener: (context, state) {
          if (state is RedeemLoadingState) {
            EasyLoading.show();
          }
          if (state is RedeemSuccessState) {
            EasyLoading.dismiss();
            context.read<RedeemCheckBloc>().add(RedeemCheckResetEvent());
            context.read<HelperDataCubit>().resetBalanceAfterRedeem();
            codeRedeemTec.clear();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: clrBackgroundBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    width: 3,
                    color: clrNeutralGrey999.withOpacity(0.16),
                  ),
                ),
                titlePadding:
                    const EdgeInsets.only(top: 8, bottom: 0, right: 8, left: 8),
                title: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: clrWhite.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.only(
                    top: 0, bottom: 20, left: 20, right: 20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(icCheckCircle),
                    const SizedBox(height: 20),
                    Text(
                      'Kode Berhasil Digunakan!',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: clrWhite,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: clrA8A8A8.withOpacity(0.24),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Emas Yang Kamu Dapatkan Sejumlah",
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: clrWhite,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${state.voucherRedeemedEntity?.goldRedeemed.toGold4Dec()} gram",
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: clrWhite,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is RedeemFailureState) {
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
        child: _Content(t: t, codeRedeemTec: codeRedeemTec),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  final TextEditingController codeRedeemTec;

  const _Content({
    Key? key,
    required this.t,
    required this.codeRedeemTec,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        var redeemCheck = context.watch<RedeemCheckBloc>();
        if (redeemCheck.state is RedeemCheckFailureState) {
          var redeemCheckFailureS =
              (redeemCheck.state as RedeemCheckFailureState);
          if (redeemCheckFailureS.appFailure is ServerFailure) {
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
                  context.read<RedeemCheckBloc>().add(RedeemCheckResetEvent());
                },
              ),
            );
          }
        }
        var redeem = context.watch<RedeemBloc>();
        if (redeem.state is RedeemFailureState) {
          var redeemFailureS = (redeem.state as RedeemFailureState);
          if (redeemFailureS.appFailure is ServerFailure) {
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
                  double? goldRedem = double.tryParse(
                      (redeemCheck.state as RedeemCheckSuccessState?)
                              ?.voucherRedeemEntity
                              ?.goldRedeemed ??
                          '');
                  context.read<RedeemBloc>().add(RedeemNowEvent(
                        voucherCode:
                            (redeemCheck.state as RedeemCheckSuccessState?)
                                ?.voucherRedeemEntity
                                ?.code,
                        goldRedeemed: goldRedem,
                      ));
                },
              ),
            );
          }
        }
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<RedeemCheckBloc, RedeemCheckState>(
              builder: (context, state) {
                if (state is RedeemCheckLoadingState) {
                  return const SizedBox();
                  // return const MainButton(
                  //   label: 'Cek Kode Voucher',
                  //   onPressed: null,
                  // );
                }
                if (state is RedeemCheckSuccessState) {
                  return MainButton(
                    label: t.lblUse,
                    onPressed: () {
                      double? goldRedem = double.tryParse(
                          state.voucherRedeemEntity?.goldRedeemed ?? '');
                      context.read<RedeemBloc>().add(RedeemNowEvent(
                            voucherCode: state.voucherRedeemEntity?.code,
                            goldRedeemed: goldRedem,
                          ));
                    },
                  );
                }
                return const SizedBox();
                // MainButton(
                //   label: 'Cek Kode Voucher',
                //   onPressed: () {
                //     String vCode = codeRedeemTec.text
                //         .replaceAll('-', '')
                //         .replaceAll(' ', '');
                //     context
                //         .read<RedeemCheckBloc>()
                //         .add(RedeemCheckNowEvent(vCode));
                //   },
                // );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBonusBanner(
                  onBackBtnPressed: () {
                    context.goNamed(AppRoutes.beranda);
                  },
                  backScreen: AppRoutes.redeem,
                  extra: {
                    "priceSettingBloc": context.read<PriceSettingBloc>(),
                  },
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.lblEnterRedeemCode,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _redeemCodeTf(
                        context: context,
                        codeRedeemTec: codeRedeemTec,
                        isElite: isElite,
                        isWithButton: false,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<RedeemCheckBloc, RedeemCheckState>(
                          buildWhen: (previous, current) => previous != current,
                          builder: (context, state) {
                            if (state is RedeemCheckLoadingState) {
                              return Column(
                                children: [
                                  const SizedBox(height: 64),
                                  SizedBox(
                                    height: 64,
                                    width: 64,
                                    child: CircularProgressIndicator(
                                      color: clrYellow,
                                      backgroundColor:
                                          clrYellow.withOpacity(0.15),
                                      strokeWidth: 6,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    t.lblCheckingCoupon,
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isElite ? clrWhite : null,
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (state is RedeemCheckFailureState) {
                              return Column(
                                children: [
                                  const SizedBox(height: 32),
                                  Center(
                                    child: Image.asset(imgPeopleRedeemWrong),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    t.lblWrongRedeemCode,
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isElite ? clrWhite : null,
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (state is RedeemCheckSuccessState) {
                              final priceEntity = (context
                                      .read<PriceSettingBloc>()
                                      .state as PriceSettingSuccessState)
                                  .priceEntity;
                              final priceReguler = priceEntity.sellingPrice;
                              final priceElite = priceEntity.redeemElitePrice;
                              return Column(
                                children: [
                                  _voucherRedeemWidget(
                                    context,
                                    name: (state.voucherRedeemEntity?.amount ??
                                                '0') ==
                                            '0'
                                        ? 'Voucher Gramasi'
                                        : 'Nominal Voucher',
                                    value: (state.voucherRedeemEntity?.amount ??
                                                '0') ==
                                            '0'
                                        ? '${state.voucherRedeemEntity?.goldAmount ?? '-'} gram'
                                        : 'Rp ${state.voucherRedeemEntity?.amount?.toIdr() ?? '-'}',
                                    goldPricePerGram: state
                                        .voucherRedeemEntity?.sellingPrice
                                        ?.toIdr(),
                                    tax:
                                        state.voucherRedeemEntity?.tax?.toIdr(),
                                    totalGramRedeemed:
                                        state.voucherRedeemEntity?.goldRedeemed,
                                    isElite: isElite,
                                  ),
                                  const SizedBox(height: 32),
                                  if (isElite == false)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4,
                                        right: 4,
                                        bottom: 16,
                                      ),
                                      child: RegulerInformationWidget(
                                        priceRedeemReguler: priceReguler,
                                        priceRedeemElite: priceElite,
                                      ),
                                    ),
                                ],
                              );
                            }
                            //
                            if (isElite) {
                              return Center(
                                child: Image.asset(imgPeopleRedeemInitial),
                              );
                            } else {
                              final priceEntity = (context
                                      .read<PriceSettingBloc>()
                                      .state as PriceSettingSuccessState)
                                  .priceEntity;
                              final priceReguler = priceEntity.sellingPrice;
                              final priceElite = priceEntity.redeemElitePrice;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: RegulerInformationWidget(
                                  priceRedeemReguler: priceReguler,
                                  priceRedeemElite: priceElite,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _voucherRedeemWidget(
    BuildContext context, {
    String? name,
    String? value,
    String? goldPricePerGram,
    String? tax,
    String? totalGramRedeemed,
    bool isElite = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: clrGreyE5e.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: clrGreyE5e.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              name ?? '-',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              value ?? '-',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: clrA8A8A8.withOpacity(0.24),
            ),
            child: Column(
              children: [
                _label(context,
                    title: 'Harga 1 Gram',
                    value: goldPricePerGram ?? '-',
                    isElite: isElite),
                const SizedBox(height: 18),
                _label(context,
                    title: 'Pajak', value: tax ?? '-', isElite: isElite),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            decoration: BoxDecoration(
                color: clrYellow.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Didapat',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                      text: totalGramRedeemed ?? '-',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                      children: const [
                        TextSpan(
                            text: ' gram',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            )),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _label(
    BuildContext context, {
    required String title,
    required String value,
    bool isElite = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isElite ? clrWhite : clrBackgroundBlack),
        ),
        RichText(
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          text: TextSpan(
              text: 'Rp',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
              children: [
                TextSpan(
                    text: ' $value',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
              ]),
        ),
      ],
    );
  }

  Widget _redeemCodeTf({
    required BuildContext context,
    required TextEditingController codeRedeemTec,
    required bool isElite,
    bool isWithButton = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<RedeemCheckBloc, RedeemCheckState>(
            builder: (context, state) {
              bool isError = false;
              if (state is RedeemCheckFailureState) {
                isError = true;
              }
              return MainTextField(
                controller: codeRedeemTec,
                isDarkMode: isElite,
                hintText: t.lblWritedownYourVoucherCode,
                isError: isError,
                isUppercase: true,
                onChange: (value) {
                  context.read<RedeemCheckBloc>().add(RedeemCheckResetEvent());

                  String codeRedeem = value;
                  String formattedText = '';

                  // Remove hyphens from the current text
                  codeRedeem = codeRedeem.replaceAll('-', '');

                  // Add hyphens after every 4 characters
                  for (int i = 0; i < codeRedeem.length; i++) {
                    if (i > 0 && i % 4 == 0) {
                      formattedText += '-';
                    }
                    formattedText += codeRedeem[i];
                  }

                  // Update the controller with the formatted text
                  codeRedeemTec.value = codeRedeemTec.value.copyWith(
                    text: formattedText,
                    selection:
                        TextSelection.collapsed(offset: formattedText.length),
                  );

                  if (codeRedeem.length == 12) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    context
                        .read<RedeemCheckBloc>()
                        .add(RedeemCheckNowEvent(codeRedeem));
                  }
                },
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9-]*')),
                  UpperCaseInputFormatter(),
                  LengthLimitingTextInputFormatter(14),
                ],
              );
            },
          ),
        ),
        if (isWithButton)
          MainButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 46,
              vertical: 18,
            ),
            label: t.lblCheck,
            onPressed: () {
              context
                  .read<RedeemCheckBloc>()
                  .add(RedeemCheckNowEvent(codeRedeemTec.text));
            },
          ),
      ],
    );
  }
}
