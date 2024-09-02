import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/utils/app_utils.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../forgot/presentation/cubits/change_obsecure/change_obsecure_cubit.dart';
import 'blocs/change_password/change_password_bloc.dart';
import 'cubits/change_password_validation/change_password_validation_cubit.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ChangePasswordBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangePasswordValidationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangeObsecureCubit>(),
        ),
      ],
      child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is ChangePasswordLoadingState) {
            EasyLoading.show();
          }
          if (state is ChangePasswordSuccessState) {
            EasyLoading.dismiss();
            Future.delayed(const Duration(seconds: 2)).then((value) {
              context.goNamed(AppRoutes.profile);
            });
            DialogUtils.success(
              context: context,
              barrierDismissible: false,
              firstDesc: '${t.lblChangePassword} ${t.lblSuccess}',
            );
          }
          if (state is ChangePasswordFailureState) {
            if (state.appFailure is ServerFailure) {
              EasyLoading.showError(t.lblSomethingWrong);
            }
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  _Content({
    Key? key,
  }) : super(key: key);

  final _oldPasswordTec = TextEditingController();
  final _oldPasswordFocus = FocusNode();
  final _newPasswordTec = TextEditingController();
  final _newPasswordFocus = FocusNode();
  final _newPasswordConfirmationTec = TextEditingController();
  final _newPasswordConfirmarionFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblChangePassword,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.profile);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MainButton(
          label: t.lblSave,
          onPressed: () {
            context.read<ChangePasswordValidationCubit>().validate(
                  t,
                  _oldPasswordTec.text,
                  _newPasswordTec.text,
                  _newPasswordConfirmationTec.text,
                );
            final isValidated =
                context.read<ChangePasswordValidationCubit>().isValidated;
            if (isValidated) {
              context.read<ChangePasswordBloc>().add(ChangePasswordPressed(
                    oldPassword: _oldPasswordTec.text,
                    newPassword: _newPasswordTec.text,
                    newPasswordConfirmation: _newPasswordConfirmationTec.text,
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
              const SizedBox(height: 32),
              BlocBuilder<ChangePasswordValidationCubit,
                  ChangePasswordValidationState>(
                buildWhen: (previous, current) =>
                    previous.oldPasswordError != current.oldPasswordError,
                builder: (context, state) {
                  return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        title: t.lblOldPassword,
                        titleColor: clrBackgroundBlack.withOpacity(0.75),
                        controller: _oldPasswordTec,
                        focusNode: _oldPasswordFocus,
                        hintText: 'masukkan kata sandi lama..',
                        onFieldSubmitted: (_) {
                          _newPasswordFocus.requestFocus();
                        },
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'^[a-zA-Z0-9@#$!%^&*_|/-=%^&*()_+{}\[\]:;<>,.?~\\-]+$')),
                        ],
                        isError: (state.oldPasswordError ?? '').isNotEmpty,
                        errorText: state.oldPasswordError,
                        isDarkMode: false,
                        suffixIcon: IconButton(
                          onPressed: () => context
                              .read<ChangeObsecureCubit>()
                              .changeObsOldPassword(
                                  !obsecureState.isOldPassword),
                          icon: Icon(
                            obsecureState.isOldPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: clrNeutralGrey999.withOpacity(0.5),
                          ),
                        ),
                        onChange: (value) {
                          context
                              .read<ChangePasswordValidationCubit>()
                              .validateOldPassword(t, _oldPasswordTec.text);
                        },
                        obsecureText: obsecureState.isOldPassword,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              BlocBuilder<ChangePasswordValidationCubit,
                  ChangePasswordValidationState>(
                builder: (context, state) {
                  return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        title: t.lblNewPassword,
                        titleColor: clrBackgroundBlack.withOpacity(0.75),
                        controller: _newPasswordTec,
                        focusNode: _newPasswordFocus,
                        hintText: 'masukkan kata sandi baru..',
                        onFieldSubmitted: (_) {
                          _newPasswordConfirmarionFocus.requestFocus();
                        },
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'^[a-zA-Z0-9@#$!%^&*_|/-=%^&*()_+{}\[\]:;<>,.?~\\-]+$')),
                        ],
                        isError: (state.newPasswordError ?? '').isNotEmpty,
                        errorText: state.newPasswordError,
                        isDarkMode: false,
                        suffixIcon: IconButton(
                          onPressed: () => context
                              .read<ChangeObsecureCubit>()
                              .changeObsNewPassword(
                                  !obsecureState.isNewPassword),
                          icon: Icon(
                            obsecureState.isNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: clrNeutralGrey999.withOpacity(0.5),
                          ),
                        ),
                        onChange: (value) {
                          context
                              .read<ChangePasswordValidationCubit>()
                              .validateNewPassword(t, _newPasswordTec.text);
                          context
                              .read<ChangePasswordValidationCubit>()
                              .validateConfirmPassword(t, _newPasswordTec.text,
                                  _newPasswordConfirmationTec.text);
                        },
                        obsecureText: obsecureState.isNewPassword,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              BlocBuilder<ChangePasswordValidationCubit,
                  ChangePasswordValidationState>(
                builder: (context, state) {
                  return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        title: t.lblNewPasswordConfirmation,
                        titleColor: clrBackgroundBlack.withOpacity(0.75),
                        controller: _newPasswordConfirmationTec,
                        focusNode: _newPasswordConfirmarionFocus,
                        hintText: 'masukkan ulang kata sandi baru..',
                        onFieldSubmitted: (_) {
                          // _dobFocus.requestFocus();
                        },
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'^[a-zA-Z0-9@#$!%^&*_|/-=%^&*()_+{}\[\]:;<>,.?~\\-]+$')),
                        ],
                        isError:
                            (state.newPasswordConfirmError ?? '').isNotEmpty,
                        errorText: state.newPasswordConfirmError,
                        isDarkMode: false,
                        suffixIcon: IconButton(
                          onPressed: () => context
                              .read<ChangeObsecureCubit>()
                              .changeObsConfirmPassword(
                                  !obsecureState.isConfirmPassword),
                          icon: Icon(
                            obsecureState.isConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: clrNeutralGrey999.withOpacity(0.5),
                          ),
                        ),
                        onChange: (value) {
                          context
                              .read<ChangePasswordValidationCubit>()
                              .validateConfirmPassword(t, _newPasswordTec.text,
                                  _newPasswordConfirmationTec.text);
                        },
                        obsecureText: obsecureState.isConfirmPassword,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
