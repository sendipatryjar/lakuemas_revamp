// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../cores/widgets/main_back_button.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/constants/otp_type.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_button.dart';
import '../domain/entities/otp_choose_entity.dart';
import 'blocks/otp/otp_bloc.dart';
import 'widgets/otp_image_content_widget.dart';

class OtpChooseScreen extends StatelessWidget {
  final String? parentScreenName;
  final OtpChooseEntity? otpChooseEntity;
  final bool isForgotPassword;
  final bool isForgotPin;
  final bool isPrivyRegister;
  final String? backScreen;
  final String? nextScreen;
  final Map<String, Object?> extra;

  const OtpChooseScreen({
    super.key,
    required this.parentScreenName,
    required this.otpChooseEntity,
    this.isForgotPassword = false,
    this.isForgotPin = false,
    this.isPrivyRegister = false,
    this.backScreen,
    this.nextScreen = AppRoutes.beranda,
    this.extra = const {},
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state is OtpLoading) {
          EasyLoading.show();
        }
        if (state is OtpFailure) {
          EasyLoading.showError(
            state.message ?? t.lblSomethingWrong,
            dismissOnTap: true,
          );
        }
        if (state is OtpSuccess) {
          if (state.otp == Otp.resend) return;
          if (state.otp == Otp.verify) return;
          EasyLoading.dismiss();
          Map<String, dynamic> extraForForgotPin = {};
          //! only called when login
          String routeName = AppRoutes.otpLogin;
          if (parentScreenName == AppRoutes.register) {
            routeName = AppRoutes.otpRegister;
          }
          if (parentScreenName == AppRoutes.profile) {
            routeName = AppRoutes.otpValidate;
          }
          if (parentScreenName == AppRoutes.pin) {
            routeName = AppRoutes.otpPin;
            extraForForgotPin = {
              'pinType': '${PinType.validate}',
              'backScreenOtpPin': backScreen ?? '',
              'nextScreenOtpPin': nextScreen ?? '',
            };
          }
          context.goNamed(
            routeName,
            extra: {
              ...extra,
              'parentScreenName': parentScreenName,
              'phoneNumber': otpChooseEntity?.phoneNumber,
              'email': otpChooseEntity?.email,
              ...extraForForgotPin,
              'username': (state.otpType == 0
                      ? otpChooseEntity?.email
                      : otpChooseEntity?.phoneNumber) ??
                  '',
              'otpType': state.otpType != null ? '${state.otpType}' : '',
              'bloc': context.read<OtpBloc>(),
            },
          );
        }
      },
      child: _Content(
        isForgotPassword: isForgotPassword,
        t: t,
        isForgotPin: isForgotPin,
        isPrivyRegister: isPrivyRegister,
        parentScreenName: parentScreenName,
        otpChooseEntity: otpChooseEntity,
        extra: extra,
        backScreen: backScreen,
        nextScreen: nextScreen,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.isForgotPassword,
    required this.t,
    required this.isForgotPin,
    required this.isPrivyRegister,
    required this.parentScreenName,
    required this.otpChooseEntity,
    required this.extra,
    required this.backScreen,
    required this.nextScreen,
  });

  final bool isForgotPassword;
  final AppLocalizations t;
  final bool isForgotPin;
  final isPrivyRegister;
  final String? parentScreenName;
  final OtpChooseEntity? otpChooseEntity;
  final Map<String, Object?> extra;
  final String? backScreen;
  final String? nextScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrBackgroundBlack,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isForgotPassword
              ? t.lblForgotPassword
              : isForgotPin
                  ? 'Lupa Pin'
                  : 'OTP',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            if (parentScreenName == AppRoutes.profile) {
              context.goNamed(
                AppRoutes.profile,
              );
              return;
            }
            context.pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: OtpImageContentWidget(
                title: t.lblOtpVerification,
                subTitle: t.lblOtpVerificationDesc(''),
              ),
            ),
            if ((otpChooseEntity?.phoneNumber ?? '').isNotEmpty ||
                isForgotPassword) ...[
              _button(
                btnText: t.lblSendOtpViaSms,
                icon: icOtpSms,
                onTap: () {
                  if (isForgotPassword) {
                    context.goNamed(
                      AppRoutes.forgotPassword,
                      extra: {
                        ...extra,
                        'smsOTP': true,
                        'emailOTP': false,
                      },
                    );
                    return;
                  }
                  // if (isForgotPin) {
                  //   context.goNamed(
                  //     AppRoutes.otpForgotPin,
                  //     pathParameters: {
                  //       'pinType': '${PinType.validate}',
                  //       'backScreen': backScreen ?? '',
                  //       'nextScreen': nextScreen ?? '',
                  //     },
                  //     queryParameters: {
                  //       'parentScreenName': AppRoutes.pin,
                  //     },
                  //     extra: {
                  //       ...extra,
                  //       'smsOTP': true,
                  //       'emailOTP': false,
                  //     },
                  //   );
                  //   return;
                  // }

                  int otpLocation = OtpLocation.verify;
                  if (parentScreenName == AppRoutes.login) {
                    otpLocation = OtpLocation.login;
                  }
                  if (parentScreenName == AppRoutes.register ||
                      isPrivyRegister) {
                    otpLocation = OtpLocation.register;
                  }
                  if (parentScreenName == AppRoutes.pin) {
                    otpLocation = OtpLocation.forgotPin;
                  }
                  context.read<OtpBloc>().add(OtpSendPressed(
                        username: otpChooseEntity?.phoneNumber ?? '',
                        otpType: 1,
                        otpLocation: otpLocation,
                      ));
                },
              ),
              const SizedBox(height: 20),
            ],
            if ((otpChooseEntity?.email ?? '').isNotEmpty ||
                isForgotPassword) ...[
              _button(
                btnText: t.lblSendOtpViaEmail,
                icon: icOtpEmail,
                onTap: () {
                  if (isForgotPassword) {
                    context.goNamed(
                      AppRoutes.forgotPassword,
                      extra: {
                        ...extra,
                        'smsOTP': false,
                        'emailOTP': true,
                      },
                    );
                    return;
                  }
                  // if (isForgotPin) {
                  //   context.goNamed(
                  //     AppRoutes.otpForgotPin,
                  //     pathParameters: {
                  //       'pinType': '${PinType.validate}',
                  //       'backScreen': backScreen ?? '',
                  //       'nextScreen': nextScreen ?? '',
                  //     },
                  //     queryParameters: {
                  //       'parentScreenName': AppRoutes.pin,
                  //     },
                  //     extra: {
                  //       ...extra,
                  //       'smsOTP': false,
                  //       'emailOTP': true,
                  //     },
                  //   );
                  //   return;
                  // }

                  int otpLocation = OtpLocation.verify;
                  if (parentScreenName == AppRoutes.login) {
                    otpLocation = OtpLocation.login;
                  }
                  if (parentScreenName == AppRoutes.register ||
                      isPrivyRegister) {
                    otpLocation = OtpLocation.register;
                  }
                  if (parentScreenName == AppRoutes.pin) {
                    otpLocation = OtpLocation.forgotPin;
                  }
                  context.read<OtpBloc>().add(OtpSendPressed(
                        username: otpChooseEntity?.email ?? '',
                        otpType: 0,
                        otpLocation: otpLocation,
                      ));
                },
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _button({
    required String btnText,
    required String icon,
    Function()? onTap,
  }) {
    return MainButton(
      label: btnText,
      labelTextAlign: TextAlign.start,
      leadingWidget: Image.asset(
        icon,
        height: 32,
        width: 32,
      ),
      onPressed: onTap,
    );
  }
}
