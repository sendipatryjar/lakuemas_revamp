import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../../cores/constants/app_color.dart';
import '../../../../../cores/constants/img_assets.dart';
import '../../../../../cores/constants/kyc_status.dart';
import '../../../../../cores/constants/pin_type.dart';
import '../../../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../../../cores/routes/app_routes.dart';
import '../../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../../cores/utils/dialog_utils.dart';
import '../../../../../cores/utils/text_utils.dart';
import '../../../../../cores/widgets/main_back_button.dart';
import '../../../../../cores/widgets/main_banner.dart';
import '../../../../../cores/widgets/main_button.dart';
import '../../../../../cores/widgets/main_dropdown_search.dart';
import '../../../../../cores/widgets/main_text_field.dart';
import '../../../domain/entities/get_banks_entity.dart';
import '../../blocs/bank_account/bank_account_bloc.dart';
import '../../blocs/get_banks/get_banks_bloc.dart';
import '../../blocs/get_kyc_data/get_kyc_data_bloc.dart';
import '../../cubits/bank_account/bank_account_cubit.dart';
import '../../cubits/bank_account_validation/bank_account_validation_cubit.dart';
import '../../widgets/field_container_widget.dart';

class BankAccountVerificationScreen extends StatelessWidget {
  final int? initialBankId;
  final bool? isResult;
  const BankAccountVerificationScreen({
    super.key,
    this.initialBankId,
    this.isResult = false,
  });

  void _confirm(
    BuildContext context,
    TextEditingController accountNumberTec,
    int bankId,
  ) {
    final t = AppLocalizations.of(context)!;
    DialogUtils.confirm(
      context: context,
      barrierDismissible: true,
      firstDesc: t.lblPopUpConfirmTitle,
      secondDesc: t.lblPopUpConfirmDesc,
      btnText: t.lblConfirm,
      btnTextLater: t.lblLater,
      btnConfirm: () {
        final bankAccountState = context.read<BankAccountCubit>().state;
        final bankId = bankAccountState.bankAccountEntity?.id;
        context.read<BankAccountBloc>().add(
              BankAccountKycPressedEvent(
                accountNumberTec.text,
                bankId ?? 0,
              ),
            );
        context.pop();
      },
      btnLater: () {
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    TextEditingController accountNumberTec = TextEditingController();
    int bankId = 0;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<GetBanksBloc>()..add(const BankAccountGetEvent()),
        ),
        BlocProvider(
          create: (context) => sl<GetKycDataBloc>()..add(GetKycTriggered()),
        ),
        BlocProvider(create: (context) => sl<BankAccountCubit>()),
        BlocProvider(create: (context) => sl<BankAccountBloc>()),
        BlocProvider(create: (context) => sl<BankAccountValidationCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<BankAccountBloc, BankAccountState>(
            listener: (context, state) {
              if (state is BankAccountLoadingState) {
                EasyLoading.show();
              }
              if (state is BankAccountSuccessState) {
                EasyLoading.dismiss();
                context.read<HelperDataCubit>().resetDataAfterTrx();
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  context.goNamed(AppRoutes.profile);
                });
                DialogUtils.success(
                  context: context,
                  barrierDismissible: true,
                  firstDesc: t.lblConfirmDataSuccess,
                  secondDesc: t.lblConfirmDataSuccessDesc,
                  btnText: t.lblBack,
                  btnOnPressed: () {},
                );
              }
              if (state is BankAccountFailureState) {
                EasyLoading.showError(
                  '${state.message}',
                  dismissOnTap: true,
                );
              }
            },
          ),
          BlocListener<BankAccountCubit, BankAccountStateCubit>(
            listener: (context, state) {
              if (isResult != true) {
                accountNumberTec.text = '';
              }
              context.read<BankAccountValidationCubit>().validateAccountBank(
                    t: t,
                    bankAccountEntity: state.bankAccountEntity,
                  );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblAccountVerification,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.goNamed(AppRoutes.accountVerification);
              },
            ),
          ),
          bottomNavigationBar: BlocBuilder<GetKycDataBloc, GetKycDataState>(
              builder: (context, kycDataState) {
            int? status;
            if (kycDataState is GetKycDataSuccessState) {
              status = kycDataState.kycData?['account_number']?.status;
            }
            if (isResult == true) {
              if (status == KycStatus.onProgress ||
                  status == KycStatus.verified) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MainButton(
                    label: t.lblBackToBeranda,
                    onPressed: () => context.goNamed(AppRoutes.beranda),
                  ),
                );
              }
              if (status == KycStatus.rejected) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MainButton(
                    label: 'Ulangi Proses Verifikasi',
                    onPressed: () {
                      context.goNamed(AppRoutes.pin, extra: {
                        'pinType': '${PinType.validate}',
                        'backScreenPin': AppRoutes.accountVerification,
                        'nextScreenPin': AppRoutes.accountVerificationBank,
                        'eliteCubit': context.read<EliteCubit>(),
                      });
                    },
                  ),
                );
              }
            }
            return BlocBuilder<BankAccountValidationCubit,
                BankAccountValidationState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: MainButton(
                    label: t.lblSave,
                    onPressed: () {
                      var bankAcc = context
                          .read<BankAccountCubit>()
                          .state
                          .bankAccountEntity;
                      context.read<BankAccountValidationCubit>().validate(
                            t: t,
                            accountNumber: accountNumberTec.text,
                            bankAccountEntity: bankAcc,
                          );

                      final isValid =
                          context.read<BankAccountValidationCubit>().isValidd;
                      if (isValid) {
                        _confirm(context, accountNumberTec, bankId);
                      }
                    },
                  ),
                );
              },
            );
          }),
          body: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<GetKycDataBloc, GetKycDataState>(
                  builder: (context, state) {
                    int? status;
                    String? reason;
                    if (state is GetKycDataSuccessState) {
                      status = state.kycData?['account_number']?.status;
                      reason = state.kycData?['account_number']?.reason;
                    }
                    if (isResult == true) {
                      if (status == KycStatus.verified) {
                        return const SizedBox();
                      }
                      if (status == KycStatus.rejected) {
                        return Container(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20,
                            top: 20,
                          ),
                          child: MainBanner(
                            content: Row(
                              children: [
                                Image.asset(
                                  icWarningRed,
                                  height: 16,
                                  width: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    reason ??
                                        'Maaf, proses verifikasimu gagal karena lorem ipsum dolor sit amet, silahkan ajukan ulang',
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
                _section(context, accountNumberTec, bankId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, TextEditingController accountNumberTec,
      int bankId) {
    final t = AppLocalizations.of(context)!;
    return BlocBuilder<GetKycDataBloc, GetKycDataState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, kycDataState) {
        if (kycDataState is GetKycDataSuccessState) {
          int? status = kycDataState.kycData?['account_number']?.status;
          if (isResult == true) {
            accountNumberTec.text =
                kycDataState.kycData?['account_number']?.number ?? '';
          }

          return FieldContainerWidget(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            title: isResult == true ? "Informasi Rekening" : null,
            status: isResult == true ? status : null,
            content: Column(
              children: [
                KycFieldTitleWidget(
                  title: t.lblBankName,
                  // status: isResult == true ? status : null,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<GetBanksBloc, GetBanksState>(
                        buildWhen: (previous, current) => previous != current,
                        builder: (context, state) {
                          List<GetBanksEntity> items = [];

                          if (state is GetBanksLoadingState) {
                            items = const [];
                          }
                          if (state is GetBanksSuccessState) {
                            items = state.data;
                          }
                          if (initialBankId != null) {
                            context
                                .read<BankAccountCubit>()
                                .initBank(initialBankId!, items);
                          }

                          return BlocBuilder<BankAccountCubit,
                              BankAccountStateCubit>(
                            buildWhen: (previous, current) =>
                                previous.bankAccountEntity !=
                                current.bankAccountEntity,
                            builder: (context, state) {
                              return MainDropDownSearch<GetBanksEntity>(
                                hintText: t.lblHintChooseBank,
                                items: items,
                                itemAsString: (value) => value.bank ?? '',
                                selectedItem: state.bankAccountEntity,
                                onChanged: (value) {
                                  context
                                      .read<BankAccountCubit>()
                                      .changeBanks(value);
                                },
                                state: isResult == true
                                    ? MainDropdownSearchState.disabled
                                    : MainDropdownSearchState.active,
                              );
                            },
                          );
                        },
                      ),
                      BlocBuilder<BankAccountValidationCubit,
                          BankAccountValidationState>(
                        buildWhen: (previous, current) =>
                            (previous.isBankError != current.isBankError) ||
                            (previous.bankErrorMessages !=
                                current.bankErrorMessages),
                        builder: (context, state) {
                          if (state.isBankError == false &&
                              (state.bankErrorMessages ?? '').isEmpty) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              left: 4,
                              right: 4,
                            ),
                            child: Text(
                              state.bankErrorMessages ?? '',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: clrRed,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                KycFieldTitleWidget(
                  title: t.lblAccountNumber,
                  // status: isResult == true ? status : null,
                  content: BlocBuilder<BankAccountValidationCubit,
                      BankAccountValidationState>(
                    builder: (context, state) {
                      return MainTextField(
                        hintText: t.lblHintAccountNumber,
                        controller: accountNumberTec,
                        isDarkMode: false,
                        textInputType: TextInputType.number,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        // isError: (isResult == true && status == KycStatus.rejected)
                        //     ? true
                        //     : (state.isAccountNumberError ?? false),
                        isError: (state.isAccountNumberError ?? false),
                        errorText: state.accountNumberErrorMessages,
                        enabled: isResult != true,
                        onChange: (value) => context
                            .read<BankAccountValidationCubit>()
                            .validateAccountNumber(
                              t: t,
                              value: value,
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
