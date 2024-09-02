import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/constants/secure_storage_key.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/services/secure_storage_service.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../_core/user/data/models/user_data_model.dart';
import 'blocs/pin/pin_bloc.dart';
import 'cubits/cubit/pin_create_helper_cubit.dart';
import 'cubits/pin_typing/pin_typing_cubit.dart';
import 'widgets/main_pin_widget.dart';
import 'widgets/numpad_widget.dart';

class PinScreen extends StatelessWidget {
  final int initialPinType;
  final String? backScreen;
  final String? nextScreen;
  final Map<String, Object?> extra;

  const PinScreen({
    super.key,
    required this.initialPinType,
    this.backScreen,
    this.nextScreen = AppRoutes.beranda,
    this.extra = const {},
  });

  void _action(BuildContext context, PinTypingState state, int? pinType) {
    switch (pinType) {
      case PinType.create:
        context.read<PinCreateHelperCubit>().updatePin(state.pin);
        context.read<PinCreateHelperCubit>().updatePinType(1);
        context.read<PinTypingCubit>().erase(isDeleteAll: true);
        break;
      case PinType.createConfirmation:
        context.read<PinCreateHelperCubit>().updatePinConfirmation(state.pin);
        context.read<PinBloc>().add(PinCreateSubmitEvent(
              pin: context.read<PinCreateHelperCubit>().state.pin,
              pinConfirmation:
                  context.read<PinCreateHelperCubit>().state.pinConfirmation,
            ));
        break;
      case PinType.validate:
        context.read<PinBloc>().add(PinValidateEvent(pin: state.pin));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PinTypingCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<PinBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              sl<PinCreateHelperCubit>()..updatePinType(initialPinType),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PinTypingCubit, PinTypingState>(
            listener: (context, state) {
              switch (state.pinStateEn) {
                case PinStateEn.submited:
                  final pinType =
                      context.read<PinCreateHelperCubit>().state.pinType;
                  _action(context, state, pinType);
                  break;
                default:
              }
            },
          ),
          BlocListener<PinBloc, PinState>(
            listener: (context, state) {
              if (state is PinLoadingState) {
                EasyLoading.show();
              }
              if (state is PinSuccessState) {
                final pinHelperState =
                    context.read<PinCreateHelperCubit>().state;
                if (pinHelperState.pinType == PinType.createConfirmation) {
                  context.read<HelperDataCubit>().alreadyInputPin(true);
                  EasyLoading.showSuccess('create pin success');
                  context.goNamed(AppRoutes.beranda);
                  // context.read<PinCreateHelperCubit>().updatePinType(2);
                  // context.read<PinCreateHelperCubit>().deleteAll();
                  // context.read<PinTypingCubit>().erase(isDeleteAll: true);
                }
                if (pinHelperState.pinType == PinType.validate) {
                  context.read<HelperDataCubit>().alreadyInputPin(true);
                  EasyLoading.dismiss();
                  Map<String, String> params = {};
                  Map<String, Object?> extra = {...this.extra};
                  if (nextScreen == AppRoutes.accountVerificationBank) {
                    params = {'initialBankId': '0'};
                  }
                  if (nextScreen == AppRoutes.paymentConfirmation ||
                      nextScreen == AppRoutes.sellGoldConfirmation) {
                    extra = {
                      ...this.extra,
                      'isValidated': true,
                      'isElite': context.read<EliteCubit>().state.toString(),
                    };
                  }
                  if (nextScreen == AppRoutes.transferDetails ||
                      nextScreen == AppRoutes.lakuSaveDetail ||
                      nextScreen == AppRoutes.physicalPullPayment ||
                      nextScreen == AppRoutes.cashWithdrawalDetails ||
                      nextScreen == AppRoutes.lakuTradeDetail ||
                      nextScreen == AppRoutes.eliteDetailsOrder ||
                      nextScreen == AppRoutes.eliteDetailsOrderVoucher) {
                    extra = {
                      ...this.extra,
                      'isValidated': true,
                      'isElite': context.read<EliteCubit>().state.toString(),
                    };
                  }
                  context.goNamed(
                    (nextScreen ?? "").isEmpty
                        ? AppRoutes.beranda
                        : nextScreen!,
                    pathParameters: params,
                    extra: extra,
                  );
                }
              }
              if (state is PinFailureState) {
                context.read<PinTypingCubit>().erase(isDeleteAll: true);
                String messageError =
                    errorMessage(state.appFailure) ?? t.lblSomethingWrong;
                EasyLoading.showError(messageError, dismissOnTap: true);
              }
            },
          ),
        ],
        child: _Content(
          backScreen: backScreen,
          nextScreen: nextScreen,
          extra: extra,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String? backScreen;
  final String? nextScreen;
  final Map<String, dynamic>? extra;
  const _Content({
    this.backScreen,
    this.nextScreen,
    this.extra,
  });

  void _onBackPressed(BuildContext context) {
    final currPinType = context.read<PinCreateHelperCubit>().state.pinType;
    appPrint('currPinType: $currPinType');
    if (currPinType == PinType.createConfirmation) {
      context.read<PinCreateHelperCubit>().updatePinType(0);
      context.read<PinCreateHelperCubit>().deleteAll();
      context.read<PinTypingCubit>().erase(isDeleteAll: true);
      return;
    }
    if (currPinType == PinType.validate && (backScreen ?? "").isNotEmpty) {
      try {
        context.goNamed(
          backScreen!,
          extra: {
            'isBack': true,
            ...(extra ?? {}),
            'isElite': context.read<EliteCubit>().state.toString(),
          },
        );
      } catch (e) {
        context.goNamed(
          backScreen!,
          extra: extra,
        );
      }

      return;
    }
    final t = AppLocalizations.of(context)!;
    DialogUtils.confirm(
      context: context,
      barrierDismissible: true,
      firstDesc: t.lblExitAppConfirm,
      btnText: t.lblYesExitApp,
      btnTextLater: t.lblStayToTheApp,
      btnConfirm: () {
        context.pop();
        SecureStorageService().logout(context).then((value) {
          context.goNamed(AppRoutes.login);
        });
      },
      btnLater: () {
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvoked: (val) {
        _onBackPressed(context);
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 2000) {
            _onBackPressed(context);
          }
        },
        child: Scaffold(
          backgroundColor: clrBackgroundBlack,
          appBar: AppBar(
            centerTitle: true,
            title: BlocBuilder<PinCreateHelperCubit, PinCreateHelperState>(
              builder: (context, state) {
                return Text(
                  _title(t, state.pinType),
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            leading: MainBackButton(
              onPressed: () {
                _onBackPressed(context);
              },
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LayoutBuilder(builder: (context, ctr) {
                    double height = 280;
                    if (ctr.maxWidth < 360) {
                      height = 200;
                    }
                    return SizedBox(
                      height: height,
                      child: BlocBuilder<PinBloc, PinState>(
                        builder: (context, state) {
                          bool isError = false;
                          String errorText = '';
                          if (state is PinFailureState) {
                            isError = true;
                            errorText = errorMessage(state.appFailure!) ??
                                t.lblSomethingWrong;
                          }
                          return MainPinWidget(
                            errorText: errorText,
                            errorTextColor:
                                errorText.toLowerCase().contains('pin 3x')
                                    ? clrRed.withOpacity(0.75)
                                    : null,
                            isError: isError,
                            onForgotPinPressed: () {
                              String? phoneNumber;
                              String? email;
                              sl<SecureStorageService>()
                                  .readSecureData(ssUserData)
                                  .then((value) {
                                var userDataEntity = UserDataModel.fromJson(
                                    jsonDecode(value ?? ''));
                                if (userDataEntity.isPhoneNumberVerified == 1) {
                                  phoneNumber = userDataEntity.handphone;
                                }
                                if (userDataEntity.isEmailVerified == 1) {
                                  email = userDataEntity.email;
                                }
                                context.goNamed(
                                  AppRoutes.otpChooseForgotPin,
                                  extra: {
                                    'pinType': '${PinType.validate}',
                                    'backScreenOtpChoose': backScreen ?? '',
                                    'nextScreenOtpChoose': nextScreen ?? '',
                                    'parentScreenName': AppRoutes.pin,
                                    'phoneNumber': phoneNumber,
                                    'email': email,
                                    ...(extra ?? {}),
                                  },
                                );
                              });
                            },
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  const NumpadWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _title(AppLocalizations t, int pinType) {
    switch (pinType) {
      case PinType.validate:
        return t.lblInputPin;
      default:
        return t.lblRegister;
    }
  }
}
