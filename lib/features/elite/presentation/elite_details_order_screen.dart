import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/extensions/date_extension.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/checkbox/main_checkbox.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../data/models/elite_register_req.dart';
import '../domain/entities/elite_register_entity.dart';
import 'blocs/elite_blocs.dart';
import 'cubits/elite_cubits.dart';
import 'widgets/elite_widgets.dart';

class EliteDetailsOrderScreen extends StatelessWidget {
  final EliteRegisterEntity eliteRegisterEntity;
  final bool isValidated;
  final EliteRegisterReq? eliteRegisterReq;
  final String? backScreen;
  const EliteDetailsOrderScreen({
    super.key,
    required this.eliteRegisterEntity,
    this.isValidated = false,
    this.eliteRegisterReq,
    this.backScreen,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<EliteOrderDetailsValidationCubit>(),
        ),
        BlocProvider(create: (context) {
          if (isValidated) {
            return sl<EliteConfirmRegisterBloc>()
              ..add(EliteConfirmRegisterEvents(
                  context.read<HelperDataCubit>().state.userDataEntity?.id));
          }
          return sl<EliteConfirmRegisterBloc>();
        }),
        BlocProvider(
          create: (context) => sl<EliteRegisterBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EliteConfirmRegisterBloc, EliteConfirmRegisterState>(
              listener: (_, state) {
            if (state is EliteConfirmRegisterLoadingState) {
              EasyLoading.show();
            }
            if (state is EliteConfirmRegisterSuccessState) {
              EasyLoading.dismiss();
              context.goNamed(
                AppRoutes.eliteOrderSuccess,
                extra: {
                  'eliteRegisterEntity': state.eliteRegisterEntity,
                  'eliteCubit': context.read<EliteCubit>(),
                },
              );
            }
            if (state is EliteConfirmRegisterFailureState) {
              EasyLoading.showError(
                errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                dismissOnTap: true,
              );
              context.goNamed(
                AppRoutes.eliteDetailsOrder,
                extra: {
                  'eliteCubit': context.read<EliteCubit>(),
                  'eliteRegisterReq': eliteRegisterReq,
                  'eliteRegisterEntity': eliteRegisterEntity,
                  'isValidated': false,
                  'backScreen': backScreen,
                },
              );
            }
          })
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
                    context.pop();
                  },
                ),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: BlocBuilder<EliteOrderDetailsValidationCubit,
                    EliteOrderDetailsValidationState>(
                  builder: (_, state) {
                    var paymentMethod =
                        eliteRegisterEntity.paymentMethod?.toLowerCase() ==
                            'voucher';

                    return MainButton(
                      label: t.lblConfirm,
                      onPressed: state.isTermsConditionsChecked == true
                          ? () {
                              {
                                var isValidated =
                                    formKey.currentState?.validate();
                                appPrint('isValidated: $isValidated');
                                if (isValidated == false) return;
                                appPrint('do action');
                                context.goNamed(
                                  AppRoutes.pin,
                                  extra: {
                                    'pinType': '${PinType.validate}',
                                    'backScreenPin': paymentMethod
                                        ? AppRoutes.eliteDetailsOrderVoucher
                                        : AppRoutes.eliteDetailsOrder,
                                    'nextScreenPin': paymentMethod
                                        ? AppRoutes.eliteDetailsOrderVoucher
                                        : AppRoutes.eliteDetailsOrder,
                                    'eliteCubit': context.read<EliteCubit>(),
                                    'eliteRegisterEntity': eliteRegisterEntity,
                                    'eliteRegisterReq': eliteRegisterReq,
                                    'backScreen': backScreen,
                                  },
                                );
                              }
                            }
                          : null,
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      EliteCardListWidget(
                        isElite: isElite,
                        itemLength: 5,
                        cardTitle: t.lblOrderDetail,
                        title: (index) => detailsOrderTitle(t, index),
                        subTitle: (index) => detailsOrderSubTitle(t, index),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<EliteOrderDetailsValidationCubit,
                          EliteOrderDetailsValidationState>(
                        builder: (context, state) {
                          return MainCheckbox(
                            uncheckColor: clrNeutralGrey999.withOpacity(0.50),
                            onChange: (value) {
                              context
                                  .read<EliteOrderDetailsValidationCubit>()
                                  .updateTermsConditions(value);
                            },
                            rightWidget: RichText(
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              text: TextSpan(
                                text: '${t.lblAgreeTo} ',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isElite ? clrWhite : clrBackgroundBlack,
                                ),
                                children: [
                                  TextSpan(
                                    text: t.lblTermsAndCondition,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: clrBlue,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (eliteRegisterEntity.paymentMethod
                                                ?.toLowerCase() ==
                                            'voucher') {
                                          context.goNamed(
                                              AppRoutes
                                                  .eliteTermsConditionDetailOrderVoucher,
                                              extra: {
                                                'eliteCubit':
                                                    context.read<EliteCubit>(),
                                                'eliteRegisterEntity':
                                                    eliteRegisterEntity,
                                                'eliteRegisterReq':
                                                    eliteRegisterReq,
                                                'backScreen': backScreen,
                                              });
                                          return;
                                        }
                                        context.goNamed(
                                            AppRoutes
                                                .eliteTermsConditionDetailOrder,
                                            extra: {
                                              'eliteCubit':
                                                  context.read<EliteCubit>(),
                                              'eliteRegisterEntity':
                                                  eliteRegisterEntity,
                                              'eliteRegisterReq':
                                                  eliteRegisterReq,
                                              'backScreen': backScreen,
                                            });
                                      },
                                  ),
                                  TextSpan(
                                      text: ' ${t.lblLakuemasService}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.6,
                                        fontWeight: FontWeight.w500,
                                        color: isElite
                                            ? clrWhite
                                            : clrBackgroundBlack,
                                      )),
                                ],
                              ),
                            ),
                          );
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

  String detailsOrderTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblPackageType;
      case 1:
        return t.lblActiveUntil;
      case 2:
        return t.lblCost;
      case 3:
        return t.lblPaymentMethod;
      case 4:
        return t.lblMonthlyAutoDebet;
      default:
        return '-';
    }
  }

  String detailsOrderSubTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return 'Lakuemas Elite ${eliteRegisterEntity.packageType}';
      case 1:
        return eliteRegisterEntity.subscriptionDateEnd.toDateLongMonthStr();
      case 2:
        return '${eliteRegisterEntity.grammationPrice} gram';
      case 3:
        return 'Saldo Emas';
      case 4:
        return 'Saldo Emas';
      default:
        return '-';
    }
  }
}
