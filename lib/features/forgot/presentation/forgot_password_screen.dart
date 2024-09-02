import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import 'blocs/forgot_password/forgot_password_bloc.dart';
import 'blocs/otp_forgot/otp_forgot_bloc.dart';
import 'cubits/forgot_password/forgot_password_validation_cubit.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final bool smsOTP;
  final bool emailOTP;
  final Map<String, Object?> extra;

  const ForgotPasswordScreen({
    super.key,
    this.smsOTP = false,
    this.emailOTP = false,
    this.extra = const {},
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ForgotPasswordValidationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ForgotPasswordBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<OtpForgotBloc>(),
        ),
      ],
      child: _Content(
        smsOTP: smsOTP,
        emailOTP: emailOTP,
        extra: extra,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final bool smsOTP;
  final bool emailOTP;
  final Map<String, Object?> extra;
  _Content({
    Key? key,
    this.smsOTP = false,
    this.emailOTP = false,
    this.extra = const {},
  }) : super(key: key);

  final TextEditingController _emailTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocListener<OtpForgotBloc, OtpForgotState>(
      listener: (context, state) {
        if (state is OtpForgotLoading) {
          EasyLoading.show();
        }
        if (state is OtpForgotFailure) {
          EasyLoading.showError(
            state.message ?? t.lblSomethingWrong,
            dismissOnTap: true,
          );
        }
        if (state is OtpForgotSuccess) {
          if (state.otp == OtpForgot.resend) return;
          if (state.otp == OtpForgot.verify) return;
          EasyLoading.dismiss();
          context.goNamed(
            AppRoutes.otpForgotPassword,
            extra: {
              ...extra,
              'bloc': context.read<OtpForgotBloc>(),
              'parentScreenName': AppRoutes.forgotPassword,
              'phoneNumber': _emailTec.text,
              'email': _emailTec.text,
              'smsOTP': smsOTP,
              'emailOTP': emailOTP,
              'username':
                  (state.otpType == 0 ? _emailTec.text : _emailTec.text),
              'otpType': state.otpType != null ? '${state.otpType}' : '',
            },
            // pathParameters: {
            //   'username':
            //       (state.otpType == 0 ? _emailTec.text : _emailTec.text),
            //   'otpType': state.otpType != null ? '${state.otpType}' : '',
            // },
          );
        }
      },
      child: Scaffold(
        backgroundColor: clrBackgroundBlack,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            t.lblForgotPassword,
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
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: MainButton(
            label: t.lblSend,
            onPressed: () {
              context
                  .read<ForgotPasswordValidationCubit>()
                  .validate(t: t, email: _emailTec.text);
              final isValidated = emailOTP
                  ? context.read<ForgotPasswordValidationCubit>().isValidated
                  : context
                      .read<ForgotPasswordValidationCubit>()
                      .isValidatedPhone;
              if (isValidated) {
                context.read<OtpForgotBloc>().add(OtpSendPressed(
                      username: _emailTec.text,
                      otpType: emailOTP ? 0 : 1,
                    ));
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 64),
                Image.asset(imgForgot),
                const SizedBox(height: 26),
                if (smsOTP) ...[
                  Text(
                    'Kirim OTP Lewat SMS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: clrWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan nomor ponsel yang terdarftar di Lakuemas untuk menerima kode OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: clrWhite.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
                if (emailOTP) ...[
                  Text(
                    'Kirim OTP Lewat Email',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: clrWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan email yang terdaftar di Lakuemas untuk menerima kode OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: clrWhite.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
                BlocBuilder<ForgotPasswordValidationCubit,
                    ForgotPasswordValidationState>(
                  builder: (context, state) {
                    return MainTextField(
                      controller: _emailTec,
                      hintText: emailOTP
                          ? t.lblEmailHint
                          : 'Masukkan nomor ponsel kamu',
                      isCenterText: true,
                      textInputType: smsOTP ? TextInputType.phone : null,
                      onChange: (value) {
                        emailOTP
                            ? context
                                .read<ForgotPasswordValidationCubit>()
                                .validateEmail(t: t, value: _emailTec.text)
                            : context
                                .read<ForgotPasswordValidationCubit>()
                                .validatePhone(t: t, value: _emailTec.text);
                      },
                      isError: emailOTP
                          ? state.isEmailError ?? false
                          : state.isPhoneError ?? false,
                      errorText: emailOTP
                          ? state.emailErrorMessages
                          : state.phoneErrorMessages,
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
