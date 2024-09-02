import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../../cores/utils/bottom_sheet_utils.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../../../cores/widgets/checkbox/main_checkbox.dart';
import '../../../../cores/widgets/main_text_field.dart';
import '../../../_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../../../login/presentation/cubits/password_obsecure/password_obsecure_cubit.dart';
import '../blocs/pivacy_policy_register/privacy_policy_register_bloc.dart';
import '../blocs/register/register_bloc.dart';
import '../blocs/t_and_c_register/t_and_c_register_bloc.dart';
import '../cubits/register_validation/register_validation_cubit.dart';

class RegisterFormWidget extends StatelessWidget {
  RegisterFormWidget({
    Key? key,
  }) : super(key: key);

  final TextEditingController _fullnameTec = TextEditingController();
  final FocusNode _fullnameFocus = FocusNode();
  final TextEditingController _phoneNumberTec = TextEditingController();
  final FocusNode _phoneNumberFocus = FocusNode();
  final TextEditingController _emailTec = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _passwordTec = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<RegisterValidationCubit, RegisterValidationState>(
                buildWhen: (previous, current) =>
                    previous.isFullNameError != current.isFullNameError ||
                    previous.fullNameErrorMessages !=
                        current.fullNameErrorMessages,
                builder: (context, state) {
                  return MainTextField(
                    title: t.lblFullName,
                    controller: _fullnameTec,
                    focusNode: _fullnameFocus,
                    hintText: t.lblFullNameHint,
                    isRequired: true,
                    onFieldSubmitted: (_) {
                      _phoneNumberFocus.requestFocus();
                    },
                    textInputFormatter: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                    onChange: (value) {
                      context.read<RegisterValidationCubit>().validateFullName(
                            t: t,
                            value: _fullnameTec.text,
                          );
                    },
                    isError: state.isFullNameError ?? false,
                    errorText: state.fullNameErrorMessages,
                  );
                },
              ),
              const SizedBox(
                height: 18,
              ),
              BlocBuilder<RegisterValidationCubit, RegisterValidationState>(
                buildWhen: (previous, current) =>
                    previous.isPhoneError != current.isPhoneError ||
                    previous.phoneErrorMessages != current.phoneErrorMessages,
                builder: (context, state) {
                  return MainTextField(
                    title: t.lblPhoneNumber,
                    controller: _phoneNumberTec,
                    focusNode: _phoneNumberFocus,
                    hintText: t.lblPhoneNumberHint,
                    isRequired: true,
                    textInputType: TextInputType.phone,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                    onFieldSubmitted: (_) {
                      _emailFocus.requestFocus();
                    },
                    onChange: (value) {
                      context
                          .read<RegisterValidationCubit>()
                          .validatePhoneNumber(
                            t: t,
                            value: _phoneNumberTec.text,
                          );
                    },
                    isError: state.isPhoneError ?? false,
                    errorText: state.phoneErrorMessages,
                  );
                },
              ),
              const SizedBox(
                height: 18,
              ),
              BlocBuilder<RegisterValidationCubit, RegisterValidationState>(
                buildWhen: (previous, current) =>
                    previous.isEmailError != current.isEmailError ||
                    previous.emailErrorMessages != current.emailErrorMessages,
                builder: (context, state) {
                  return MainTextField(
                    title: t.lblEmail,
                    controller: _emailTec,
                    focusNode: _emailFocus,
                    hintText: t.lblEmailHint,
                    isRequired: true,
                    onFieldSubmitted: (_) {
                      _passwordFocus.requestFocus();
                    },
                    onChange: (value) {
                      context.read<RegisterValidationCubit>().validateEmail(
                            t: t,
                            value: _emailTec.text,
                          );
                    },
                    isError: state.isEmailError ?? false,
                    errorText: state.emailErrorMessages,
                  );
                },
              ),
              const SizedBox(
                height: 18,
              ),
              BlocBuilder<RegisterValidationCubit, RegisterValidationState>(
                buildWhen: (previous, current) =>
                    previous.isPasswordError != current.isPasswordError ||
                    previous.passwordErrorMessages !=
                        current.passwordErrorMessages,
                builder: (context, state) {
                  return BlocBuilder<PasswordObsecureCubit, bool>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        title: t.lblPassword,
                        controller: _passwordTec,
                        focusNode: _passwordFocus,
                        hintText: t.lblPasswordHint,
                        isRequired: true,
                        suffixIcon: IconButton(
                          onPressed: () => context
                              .read<PasswordObsecureCubit>()
                              .changeObsecure(!obsecureState),
                          icon: Icon(
                            obsecureState
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: clrWhite.withOpacity(0.5),
                          ),
                        ),
                        obsecureText: obsecureState,
                        onChange: (value) {
                          context
                              .read<RegisterValidationCubit>()
                              .validatePasword(
                                t: t,
                                value: _passwordTec.text,
                              );
                        },
                        isError: state.isPasswordError ?? false,
                        errorText: state.passwordErrorMessages,
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 32,
              ),
              MainCheckbox(
                onChange: (value) {
                  context
                      .read<RegisterValidationCubit>()
                      .updateTermsConditions(value);
                },
                rightWidget: BlocBuilder<TAndCRegisterBloc, TAndCRegisterState>(
                  builder: (context, state) {
                    TermsAndConditionsEntity? tacEtty;
                    if (state is TAndCRegisterSuccessState) {
                      tacEtty = state.tAndCRegister;
                    }
                    return RichText(
                      text: TextSpan(
                          text: '${t.lblAgreeTo} ',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.8,
                            fontWeight: FontWeight.w500,
                            color: clrWhite,
                          ),
                          children: [
                            TextSpan(
                              text: t.lblTermsAndCondition,
                              style: TextStyle(
                                color: clrYellow,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if ((tacEtty?.title ?? '').isNotEmpty) {
                                    BottomSheetUtils.general(
                                      context: context,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      bgColor: clrBlack080,
                                      titleText: tacEtty?.title,
                                      titleTextColor: clrWhite,
                                      content: Expanded(
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              Text(
                                                tacEtty?.description ?? '',
                                                style: TextStyle(
                                                  color: clrWhite,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                            ),
                            TextSpan(
                              text: ' ${t.lblLakuemasService}',
                            ),
                          ]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              MainCheckbox(
                onChange: (value) {
                  context
                      .read<RegisterValidationCubit>()
                      .updatePrivacyPolicy(value);
                },
                rightWidget: BlocBuilder<PrivacyPolicyRegisterBloc,
                    PrivacyPolicyRegisterState>(
                  builder: (context, state) {
                    String? privacyPolicyHtmlStr;
                    if (state is PrivacyPolicyRegisterSuccessState) {
                      privacyPolicyHtmlStr = state.htmlStr;
                    }
                    return RichText(
                      text: TextSpan(
                          text: '${t.lblAgreeTo} ',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.8,
                            fontWeight: FontWeight.w500,
                            color: clrWhite,
                          ),
                          children: [
                            TextSpan(
                              text: t.lblPrivacyPolicy,
                              style: TextStyle(
                                color: clrYellow,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if ((privacyPolicyHtmlStr ?? '').isNotEmpty) {
                                    BottomSheetUtils.general(
                                      context: context,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      bgColor: clrBlack080,
                                      titleText: t.lblPrivacyPolicy,
                                      titleTextColor: clrWhite,
                                      content: Expanded(
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(
                                            children: [
                                              Html(
                                                data:
                                                    privacyPolicyHtmlStr ?? '',
                                                style: {
                                                  "body": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                    backgroundColor:
                                                        clrBlack080,
                                                    color: clrWhite,
                                                  ),
                                                  "p": Style(
                                                    color: clrWhite,
                                                  ),
                                                  "ul": Style(
                                                    color: clrWhite,
                                                  ),
                                                  "li": Style(
                                                    color: clrWhite,
                                                  )
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                            ),
                            TextSpan(
                              text: ' ${t.lblLakuemasService}',
                            ),
                          ]),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 128,
              ),
              // Padding(
              //     padding: EdgeInsets.only(
              //         bottom: MediaQuery.of(context).viewInsets.bottom)),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: clrBackgroundBlack,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<RegisterValidationCubit, RegisterValidationState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        label: t.lblRegister,
                        onPressed: (state.isTermsConditionsChecked == true) &&
                                (state.isPrivacyPolicyChecked == true)
                            ? () {
                                context
                                    .read<RegisterValidationCubit>()
                                    .validate(
                                      t: t,
                                      fullname: _fullnameTec.text,
                                      phoneNumber: _phoneNumberTec.text,
                                      email: _emailTec.text,
                                      password: _passwordTec.text,
                                    );
                                final isValid = context
                                    .read<RegisterValidationCubit>()
                                    .isValid;
                                appPrint('isValid $isValid');
                                if (isValid) {
                                  context
                                      .read<RegisterBloc>()
                                      .add(RegisterPressed(
                                        fullName: _fullnameTec.text,
                                        phoneNumber: _phoneNumberTec.text,
                                        email: _emailTec.text,
                                        password: _passwordTec.text,
                                      ));
                                }
                              }
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                    text: '${t.lblAlreadyHaveAccount}? ',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      fontWeight: FontWeight.w500,
                      color: clrWhite,
                    ),
                    children: [
                      TextSpan(
                        text: t.lblLogin,
                        style: TextStyle(
                          color: clrYellow,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.goNamed(AppRoutes.login);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
