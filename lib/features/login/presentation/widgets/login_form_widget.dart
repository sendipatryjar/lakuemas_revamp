import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../../../cores/widgets/main_text_field.dart';
import '../blocs/login/login_bloc.dart';
import '../cubits/password_obsecure/password_obsecure_cubit.dart';

class LoginFormWidget extends StatefulWidget {
  final double height;
  const LoginFormWidget({
    Key? key,
    this.height = 502,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailOrPhoneTec = TextEditingController();
  final FocusNode _emailOrPhoneFocus = FocusNode();
  final TextEditingController _passwordTec = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          EasyLoading.show();
        }
        if (state is LoginSuccess) {
          EasyLoading.dismiss();
          context.goNamed(AppRoutes.otpChooseLogin, extra: {
            'parentScreenName': AppRoutes.login,
            'phoneNumber': state.phoneNumber,
            'email': state.email,
            'isPrivyRegister': state.isPrivyRegister,
            'loginBloc': context.read<LoginBloc>()
          });
        }
        if (state is LoginFailure) {
          EasyLoading.dismiss();
        }
      },
      child: Container(
        height: widget.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(right: 20, left: 20, top: 40),
        decoration: BoxDecoration(
          color: clrWhite,
          // borderRadius: BorderRadius.circular(30),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${t.lblWelcome}!',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        t.lblWellcomeDesc,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: clrBackgroundBlack,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        bool isError = false;
                        String? error;
                        if (state is LoginFailure) {
                          error = state.appFailure?.errors?['username'];
                          isError = (error != null) ||
                              ((state.appFailure?.errors == null) &&
                                  state.appFailure?.messages != null);
                        }
                        return MainTextField(
                          // title: 'Username',
                          controller: _emailOrPhoneTec,
                          focusNode: _emailOrPhoneFocus,
                          hintText:
                              '${t.lblEmail} ${t.lblOr} ${t.lblPhoneNumber}',
                          onFieldSubmitted: (_) {
                            _passwordFocus.requestFocus();
                          },
                          onChange: (value) {
                            context.read<LoginBloc>().add(InitialChange());
                          },
                          isError: isError,
                          errorText: error,
                          isDarkMode: false,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (context, state) {
                        bool isError = false;
                        String? error;
                        if (state is LoginFailure) {
                          error = state.appFailure?.errors?['password'];
                          isError = (error != null) ||
                              ((state.appFailure?.errors == null) &&
                                  state.appFailure?.messages != null);
                        }
                        return BlocBuilder<PasswordObsecureCubit, bool>(
                          builder: (context, state) {
                            return MainTextField(
                              controller: _passwordTec,
                              focusNode: _passwordFocus,
                              hintText: t.lblPassword,
                              isDarkMode: false,
                              suffixIcon: IconButton(
                                onPressed: () => context
                                    .read<PasswordObsecureCubit>()
                                    .changeObsecure(!state),
                                icon: Icon(
                                  state
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: clrBackgroundBlack,
                                ),
                              ),
                              onChange: (value) {
                                context.read<LoginBloc>().add(InitialChange());
                              },
                              obsecureText: state,
                              isError: isError,
                              errorText: error,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            // context.goNamed(AppRoutes.forgotPassword);
                            context.read<LoginBloc>().add(InitialChange());
                            context.goNamed(
                              AppRoutes.otpChooseForgotPassword,
                              extra: {
                                'parentScreenName': AppRoutes.login,
                                'phoneNumber': null,
                                'email': null,
                                'isForgotPassword': true,
                              },
                            );
                          },
                          child: Text(
                            t.lblForgotPassword,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              color: clrBackgroundBlack,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginFailure) {
                          if (state.appFailure?.errors == null) {
                            return InkWell(
                              onTap: state.appFailure?.code == 500
                                  ? () {
                                      context.goNamed(AppRoutes.support,
                                          extra: {
                                            'backScreen': AppRoutes.login
                                          });
                                    }
                                  : null,
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  state.message ??
                                      'Server sedang maintenance, harap menghubungi Customer Service untuk info lebih lanjut. Klik disini untuk menghubungi Customer Service',
                                  textScaler: TextScaler.linear(
                                      TextUtils.textScaleFactor(context)),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: clrRed,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        }
                        return const SizedBox(height: 20);
                      },
                    ),
                    // ignore: deprecated_member_use
                    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0)
                      const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: MainButton(
                label: t.lblLogin,
                onPressed: () {
                  context.read<LoginBloc>().add(LoginPressed(
                        context,
                        _emailOrPhoneTec.text,
                        _passwordTec.text,
                      ));
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: MainButton(
                label: 'Lanjutkan Dengan Privy',
                padding: const EdgeInsets.all(16),
                leadingWidget: Image.asset(
                  icPrivyLogoRed,
                  height: 24,
                  width: 35,
                ),
                bgColor: clrWhite,
                isExpandedLabel: false,
                onPressed: () {
                  context.goNamed(AppRoutes.loginPrivy,
                      extra: {'loginBloc': context.read<LoginBloc>()});
                },
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: double.infinity,
              child: RichText(
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: '${t.lblDontHaveAccount}? ',
                    style: TextStyle(
                      color: clrBackgroundBlack,
                    ),
                    children: [
                      TextSpan(
                        text: t.lblRegister,
                        style: TextStyle(
                          color: clrBackgroundBlack,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.read<LoginBloc>().add(InitialChange());
                            context.goNamed(AppRoutes.register);
                          },
                      ),
                    ]),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
