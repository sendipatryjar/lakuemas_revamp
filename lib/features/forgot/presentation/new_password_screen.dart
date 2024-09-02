import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../login/presentation/cubits/password_obsecure/password_obsecure_cubit.dart';
import 'blocs/forgot_password/forgot_password_bloc.dart';
import 'cubits/change_obsecure/change_obsecure_cubit.dart';
import 'cubits/forgot_password/forgot_password_validation_cubit.dart';

class NewPasswordScreen extends StatelessWidget {
  final Map<String, dynamic>? extra;
  const NewPasswordScreen({
    super.key,
    this.extra = const {},
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController newPasswordTec = TextEditingController();
    final TextEditingController confirmPasswordTec = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ForgotPasswordValidationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ForgotPasswordBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<PasswordObsecureCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangeObsecureCubit>(),
        ),
      ],
      child: _Content(
        newPasswordTec: newPasswordTec,
        confirmPasswordTec: confirmPasswordTec,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.newPasswordTec,
    required this.confirmPasswordTec,
  });

  final TextEditingController newPasswordTec;
  final TextEditingController confirmPasswordTec;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordLoadingState) {
          EasyLoading.show();
        }
        if (state is ForgotPasswordSuccessState) {
          EasyLoading.dismiss();
          DialogUtils.success(
            context: context,
            barrierDismissible: false,
            firstDesc: 'Password Barumu Sudah Berhasil Dibuat!',
            secondDesc: 'Silahkan login kembali',
            btnText: t.lblBackToLogin,
            btnOnPressed: () {
              context.goNamed(AppRoutes.login);
            },
          );
        }
        if (state is ForgotPasswordFailureState) {
          EasyLoading.showError(
            errorMessage(state.appFailure!) ?? t.lblSomethingWrong,
            dismissOnTap: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: clrBackgroundBlack,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Buat Kata Sandi Baru',
            style: TextStyle(
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
          padding: const EdgeInsets.all(20),
          child: MainButton(
            label: 'Simpan Kata Sandi',
            onPressed: context
                            .watch<ForgotPasswordValidationCubit>()
                            .isValidatedPassword ==
                        true &&
                    newPasswordTec.text.isNotEmpty &&
                    confirmPasswordTec.text.isNotEmpty
                ? () {
                    context
                        .read<ForgotPasswordValidationCubit>()
                        .validatePassword(
                          password: newPasswordTec.text,
                          confirmPassword: confirmPasswordTec.text,
                        );

                    final isValidated = context
                        .read<ForgotPasswordValidationCubit>()
                        .isValidatedPassword;

                    if (isValidated) {
                      context.read<ForgotPasswordBloc>().add(
                            ForgotPasswordPressedEvent(
                              newPasswordTec.text,
                              confirmPasswordTec.text,
                            ),
                          );
                    }
                  }
                : null,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 224,
                height: 160,
                margin: const EdgeInsets.only(top: 24, bottom: 40),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imgPeopleForgot),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BlocBuilder<ForgotPasswordValidationCubit,
                  ForgotPasswordValidationState>(
                buildWhen: (previous, current) =>
                    previous.newPasswordErrorMessage !=
                    current.newPasswordErrorMessage,
                builder: (context, state) {
                  return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        controller: newPasswordTec,
                        title: 'Kata Sandi Baru',
                        hintText: 'Kata sandi minimal 6 karakter',
                        isError: state.newPasswordErrorMessage != null,
                        errorText: state.newPasswordErrorMessage,
                        suffixIcon: IconButton(
                          onPressed: () => context
                              .read<ChangeObsecureCubit>()
                              .changeObsNewPassword(
                                  !obsecureState.isNewPassword),
                          icon: Icon(
                            obsecureState.isNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: clrWhite.withOpacity(0.5),
                          ),
                        ),
                        onChange: (value) {
                          context
                              .read<ForgotPasswordValidationCubit>()
                              .validateNewPassword(
                                password: newPasswordTec.text,
                              );
                        },
                        obsecureText: obsecureState.isNewPassword,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              BlocBuilder<ForgotPasswordValidationCubit,
                  ForgotPasswordValidationState>(
                buildWhen: (previous, current) =>
                    previous.confirmPasswordErrorMessage !=
                    current.confirmPasswordErrorMessage,
                builder: (context, state) {
                  return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        controller: confirmPasswordTec,
                        title: 'Tulis Ulang Kata Sandi Baru',
                        hintText: 'Ketik ulang kata sandi',
                        isError: state.confirmPasswordErrorMessage != null,
                        errorText: state.confirmPasswordErrorMessage,
                        suffixIcon: IconButton(
                          onPressed: () => context
                              .read<ChangeObsecureCubit>()
                              .changeObsConfirmPassword(
                                  !obsecureState.isConfirmPassword),
                          icon: Icon(
                            obsecureState.isConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: clrWhite.withOpacity(0.5),
                          ),
                        ),
                        onChange: (value) {
                          context
                              .read<ForgotPasswordValidationCubit>()
                              .validateConfirmPassword(
                                password: confirmPasswordTec.text,
                              );
                        },
                        obsecureText: obsecureState.isConfirmPassword,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
