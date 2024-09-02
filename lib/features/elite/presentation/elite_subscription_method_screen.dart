import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../data/models/elite_register_req.dart';
import 'blocs/elite_blocs.dart';
import 'cubits/elite_cubits.dart';
import 'widgets/elite_widgets.dart';

class EliteSubscriptionMethodScreen extends StatelessWidget {
  final EliteRegisterReq eliteRegisterReq;
  final String? backScreen;
  const EliteSubscriptionMethodScreen({
    super.key,
    required this.eliteRegisterReq,
    this.backScreen,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final TextEditingController activationCodeTec = TextEditingController();
    int? customerId;
    String? voucherId;
    bool? isVoucherValid;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<ElitePaymentMethodBloc>()..add(GetElitePaymentMethodEvent()),
        ),
        BlocProvider(
          create: (context) => sl<SubscriptionPackagesBloc>()
            ..add(GetSubscriptionPackagesEvent()),
        ),
        BlocProvider(
          create: (context) => sl<EliteActivationCodeBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<EliteRegisterBloc>(),
        ),
        BlocProvider(
          create: (context) => SubscriptionMethodCubit(),
        ),
        BlocProvider(
          create: (context) => SubscriptionPackagesCubit(),
        ),
        BlocProvider(
          create: (context) => sl<EliteActivationCodeValidationCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EliteActivationCodeBloc, EliteActivationCodeState>(
            listener: (context, state) {
              if (state is EliteActivationCodeLoadingState) {
                EasyLoading.show();
              }
              if (state is EliteActivationCodeSuccessState) {
                EasyLoading.dismiss();

                voucherId =
                    state.eliteActivationCodeValidationEntity.voucherCode;
                isVoucherValid =
                    state.eliteActivationCodeValidationEntity.isValid;

                EliteRegisterReq(
                  voucherId:
                      state.eliteActivationCodeValidationEntity.voucherCode,
                );
                DialogUtils.success(
                  context: context,
                  barrierDismissible: true,
                  firstDesc: t.lblSuccessActivationCodeTitle,
                  secondDesc: t.lblSuccessActivationCodeDesc,
                  btnText: t.lblContinue,
                  btnOnPressed: () {
                    // context.pop();

                    context.read<EliteRegisterBloc>().add(
                          EliteRegisterEvents(
                            customerId,
                            eliteRegisterReq.packageId,
                            eliteRegisterReq.paymentMethodId,
                            voucherId,
                            eliteRegisterReq.autoRenewalPaymentMethod,
                            eliteRegisterReq.referalCode,
                          ),
                        );
                  },
                );
              }
              if (state is EliteActivationCodeFailureState) {
                EasyLoading.dismiss();
                DialogUtils.failure(
                  context: context,
                  barrierDismissible: true,
                  firstDesc: t.lblFailureActivationCodeTitle,
                  secondDesc: t.lblFailureActivationCodeDesc,
                  btnText: t.lblBack,
                  btnOnPressed: () {
                    context.pop();
                  },
                );
              }
            },
          ),
          BlocListener<EliteRegisterBloc, EliteRegisterState>(
            listener: (context, state) {
              if (state is EliteRegisterLoadingState) {
                EasyLoading.show();
              }
              if (state is EliteRegisterSuccessState) {
                EasyLoading.dismiss();
                if (state.eliteRegisterEntity.paymentMethod?.toLowerCase() ==
                    'voucher') {
                  context.goNamed(
                    AppRoutes.eliteDetailsOrderVoucher,
                    extra: {
                      'eliteCubit': context.read<EliteCubit>(),
                      'eliteRegisterEntity': state.eliteRegisterEntity,
                      'eliteRegisterReq': eliteRegisterReq,
                      'backScreen': backScreen,
                    },
                  );
                  return;
                }
                context.goNamed(
                  AppRoutes.eliteDetailsOrder,
                  extra: {
                    'eliteCubit': context.read<EliteCubit>(),
                    'eliteRegisterEntity': state.eliteRegisterEntity,
                    'eliteRegisterReq': eliteRegisterReq,
                    'backScreen': backScreen,
                  },
                );
              }
              if (state is EliteRegisterFailureState) {
                EasyLoading.showError(
                  errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                  dismissOnTap: true,
                );
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  EasyLoading.dismiss();
                });
              }
            },
          ),
        ],
        child: BlocBuilder<EliteCubit, bool>(
          builder: (context, isElite) {
            return Scaffold(
              backgroundColor: isElite ? clrBlack080 : null,
              appBar: AppBar(
                backgroundColor: clrBackgroundBlack,
                centerTitle: true,
                title: Text(
                  t.lblRegistLakuemasElite,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: MainBackButton(
                  onPressed: () {
                    if (backScreen == AppRoutes.eliteReferal) {
                      context.goNamed(
                        AppRoutes.eliteReferal,
                        extra: {'isBack': true},
                      );
                      return;
                    }
                    context.goNamed(
                      AppRoutes.elite,
                      extra: {'isElite': isElite.toString()},
                    );
                  },
                ),
              ),
              bottomNavigationBar: _mainButton(
                context,
                activationCodeTec,
                // customerId,
                voucherId,
                isVoucherValid,
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<SubscriptionMethodCubit, int?>(
                        builder: (context, state) {
                          return SubscriptionSectionWidget(
                            isElite: isElite,
                            title: t.lblSubscriptionMethod,
                            itemLength: 2,
                            menuName: (index) =>
                                subscriptionMethodTitle(t, index),
                            menuOnTap: (index) => accOnTap(context, index),
                            radioBtn: (index) =>
                                radioBtn(index, state, (value) {
                              context
                                  .read<SubscriptionMethodCubit>()
                                  .changeOption(index);
                            }, isElite),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      BlocBuilder<SubscriptionMethodCubit, int?>(
                        builder: (context, state) {
                          if (state == 0) {
                            return ActivationCodeWidget(
                              isElite: isElite,
                              title: t.lblActivationCode,
                              itemLength: 1,
                              optionalWidget: ActivationCodeItemWidget(
                                isElite: isElite,
                                activationCodeTec: activationCodeTec,
                              ),
                              menuName: (index) =>
                                  activationCodeTitle(t, index),
                              menuOnTap: (index) => accOnTap(context, index),
                              radioBtn: (index) =>
                                  radioActivationCodeBtn(index, state, (value) {
                                context
                                    .read<SubscriptionMethodCubit>()
                                    .changeOption(index);
                              }),
                            );
                          }
                          if (state == 1) {
                            return BlocBuilder<SubscriptionPackagesBloc,
                                SubscriptionPackagesState>(
                              builder: (context, state) {
                                if (state is SubscriptionPackagesLoadingState) {
                                  return Shimmer.fromColors(
                                    baseColor: clrGreyShimmerBase,
                                    highlightColor: clrGreyShimmerHighlight,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: List.generate(
                                              3,
                                              (index) => Container(
                                                height: 96,
                                                margin: const EdgeInsets.only(
                                                    bottom: 20),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: clrWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if (state is SubscriptionPackagesSuccessState) {
                                  return SubscriptionackagesWidget(
                                      isElite: isElite,
                                      itemLength: state
                                          .subscriptionPackagesEntity.length,
                                      title: (index) =>
                                          state
                                              .subscriptionPackagesEntity[index]
                                              .packageType ??
                                          '',
                                      price: (index) =>
                                          'Rp ${state.subscriptionPackagesEntity[index].nominalPrice.toString().toIdr()} atau ${state.subscriptionPackagesEntity[index].grammationPrice} gram saldo emas',
                                      discPrice: (index) =>
                                          'Rp ${state.subscriptionPackagesEntity[index].nominalPriceDisc.toString().toIdr()} atau ${state.subscriptionPackagesEntity[index].grammationPriceDisc} gram saldo emas',
                                      onTap: (index) {
                                        final packageId = state
                                            .subscriptionPackagesEntity[index]
                                            .id;
                                        final totGrammation = state
                                            .subscriptionPackagesEntity[index]
                                            .grammationPrice;
                                        subscriptionPackagesOnTap(
                                            context, packageId!, totGrammation);
                                      },
                                      isShowBadgeDisc: (index) => (state
                                                  .subscriptionPackagesEntity[
                                                      index]
                                                  .nominalPriceDisc !=
                                              0)
                                          ? true
                                          : false,
                                      radioBtn: (index) {
                                        final packageId = state
                                            .subscriptionPackagesEntity[index]
                                            .id;
                                        final totGrammation = state
                                            .subscriptionPackagesEntity[index]
                                            .grammationPrice;
                                        return BlocBuilder<
                                            SubscriptionPackagesCubit,
                                            SubscriptionPackagesStateCubit>(
                                          builder: (context, state) {
                                            return radioSubscriptionPackageBtn(
                                                packageId!, state.index,
                                                (value) {
                                              context
                                                  .read<
                                                      SubscriptionPackagesCubit>()
                                                  .changeOption(
                                                      packageId, totGrammation);
                                            }, isElite);
                                          },
                                        );
                                      });
                                }
                                return const SizedBox();
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
            );
          },
        ),
      ),
    );
  }

  String subscriptionMethodTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblActivationCode;
      case 1:
        return t.lblSubscribeDIrect;
      default:
        return '-';
    }
  }

  String activationCodeTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblGoldBalance;
      default:
        return '-';
    }
  }

  Widget radioBtn(int index, int? groupValue, void Function(int?)? onChanged,
      bool isElite) {
    return Radio<int?>(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      fillColor: MaterialStateColor.resolveWith((states) =>
          (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75)),
    );
  }

  Widget radioActivationCodeBtn(
      int index, int? groupValue, void Function(int?)? onChanged) {
    return Radio<int?>(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: clrNeutralGrey999.withOpacity(0.50),
    );
  }

  Widget radioSubscriptionPackageBtn(int index, int? groupValue,
      void Function(Object?)? onChanged, bool isElite) {
    return Radio<int?>(
      value: index,
      groupValue: groupValue,
      onChanged: onChanged,
      fillColor: MaterialStateColor.resolveWith((states) =>
          (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75)),
    );
  }

  void accOnTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.read<SubscriptionMethodCubit>().changeOption(0);
        break;
      case 1:
        context.read<SubscriptionMethodCubit>().changeOption(1);
        break;
      default:
    }
  }

  void subscriptionPackagesOnTap(
      BuildContext context, int packageId, double? totGrammation) {
    switch (packageId) {
      case 1:
        context
            .read<SubscriptionPackagesCubit>()
            .changeOption(packageId, totGrammation);
        break;
      case 2:
        context
            .read<SubscriptionPackagesCubit>()
            .changeOption(packageId, totGrammation);
        break;
      case 3:
        context
            .read<SubscriptionPackagesCubit>()
            .changeOption(packageId, totGrammation);
        break;
      default:
    }
  }

  Widget _mainButton(
    BuildContext context,
    TextEditingController? activationCodeTec,
    // int? customerId,
    String? voucherId,
    bool? isVoucherValid,
  ) {
    final t = AppLocalizations.of(context)!;

    return BlocListener<EliteActivationCodeBloc, EliteActivationCodeState>(
      listener: (context, state) {
        if (state is EliteActivationCodeSuccessState) {
          voucherId = state.eliteActivationCodeValidationEntity.voucherCode;
          isVoucherValid = state.eliteActivationCodeValidationEntity.isValid;
        }
      },
      child: BlocBuilder<SubscriptionMethodCubit, int?>(
        builder: (context, state) {
          return state == 0
              ? const SizedBox()
              // Container(
              //     padding: const EdgeInsets.all(20),
              //     width: double.infinity,
              //     child: MainButton(
              //       label: t.lblContinue,
              //       onPressed: () {
              //         context
              //             .read<EliteActivationCodeValidationCubit>()
              //             .validate(
              //                 t: t, activationCode: activationCodeTec!.text);
              //         final isValid = context
              //             .read<EliteActivationCodeValidationCubit>()
              //             .isValid;
              //         if (isValid && isVoucherValid == true) {
              //           context.read<EliteRegisterBloc>().add(
              //                 EliteRegisterEvents(
              //                   customerId,
              //                   eliteRegisterReq.packageId,
              //                   eliteRegisterReq.paymentMethodId,
              //                   voucherId,
              //                   eliteRegisterReq.autoRenewalPaymentMethod,
              //                   eliteRegisterReq.referalCode,
              //                 ),
              //               );
              //         }
              //       },
              //     ),
              //   )
              : state == 1
                  ? BlocBuilder<ElitePaymentMethodBloc,
                      ElitePaymentMethodState>(builder: (context, state) {
                      if (state is ElitePaymentMethodSuccessState) {
                        final gramBalance =
                            state.elitePaymentMethodEntity[0].grammationBalance;

                        return BlocConsumer<SubscriptionPackagesCubit,
                            SubscriptionPackagesStateCubit>(
                          listener: (context, state) {
                            if ((state.totGrammation ?? 0) >=
                                (gramBalance ?? 0)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Saldo emas anda tidak cukup"),
                                ),
                              );
                              return;
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              child: MainButton(
                                label: '${t.lblSelect} ${t.lblPaymentMethods}',
                                onPressed: state.index != null &&
                                        (state.totGrammation ?? 0) <=
                                            (gramBalance ?? 0)
                                    ? () {
                                        context.goNamed(
                                          AppRoutes.elitePaymentMethod,
                                          extra: {
                                            'eliteRegisterReq':
                                                eliteRegisterReq.copyWith(
                                              packageId: state.index,
                                            ),
                                            'eliteCubit':
                                                context.read<EliteCubit>(),
                                            'backScreen': backScreen,
                                          },
                                        );
                                      }
                                    : null,
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    })
                  : const SizedBox();
        },
      ),
    );
  }
}
