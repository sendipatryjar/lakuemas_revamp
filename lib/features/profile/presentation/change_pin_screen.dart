import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../forgot/presentation/cubits/change_obsecure/change_obsecure_cubit.dart';
import 'blocs/change_pin/change_pin_bloc.dart';
import 'cubits/change_pin_validation/change_pin_validation_cubit.dart';

_goBackTo({
  required BuildContext context,
  required String backScreen,
  required String? pinBackScreen,
  required String? pinNextScreen,
}) {
  switch (backScreen) {
    case AppRoutes.pin:
      context.goNamed(backScreen, extra: {
        'pinType': '${PinType.validate}',
        'nextScreenPin': pinNextScreen ?? '',
        'backScreenPin': pinBackScreen ?? '',
      });
      break;
    default:
      context.goNamed(backScreen);
  }
}

class ChangePinScreen extends StatelessWidget {
  final String? backScreen;
  final String? pinBackScreen;
  final String? pinNextScreen;

  const ChangePinScreen({
    super.key,
    this.backScreen,
    this.pinBackScreen,
    this.pinNextScreen,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ChangePinBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangePinValidationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangeObsecureCubit>(),
        ),
      ],
      child: BlocListener<ChangePinBloc, ChangePinState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is ChangePinLoadingState) {
            EasyLoading.show();
          }
          if (state is ChangePinSuccessState) {
            EasyLoading.dismiss();
            Future.delayed(const Duration(seconds: 2)).then((value) {
              _goBackTo(
                context: context,
                backScreen: backScreen ?? AppRoutes.profile,
                pinBackScreen: pinBackScreen,
                pinNextScreen: pinNextScreen,
              );
            });
            DialogUtils.success(
              context: context,
              barrierDismissible: false,
              firstDesc: '${t.lblChangePin} ${t.lblSuccess}',
            );
          }
          if (state is ChangePinFailureState) {
            if (state.appFailure is ServerFailure) {
              EasyLoading.showError(t.lblSomethingWrong);
            }
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(
          backScreen: backScreen,
          pinBackScreen: pinBackScreen,
          pinNextScreen: pinNextScreen,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String? backScreen;
  final String? pinBackScreen;
  final String? pinNextScreen;
  _Content({
    Key? key,
    this.backScreen,
    this.pinBackScreen,
    this.pinNextScreen,
  }) : super(key: key);

  final _oldPinTec = TextEditingController();
  final _oldPinFocus = FocusNode();
  final _newPinTec = TextEditingController();
  final _newPinFocus = FocusNode();
  final _newPinConfirmationTec = TextEditingController();
  final _newPinConfirmarionFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblChangePin,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            _goBackTo(
              context: context,
              backScreen: backScreen ?? AppRoutes.profile,
              pinBackScreen: pinBackScreen,
              pinNextScreen: pinNextScreen,
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MainButton(
          label: t.lblSave,
          onPressed: () {
            context.read<ChangePinValidationCubit>().validate(
                  t,
                  _oldPinTec.text,
                  _newPinTec.text,
                  _newPinConfirmationTec.text,
                );
            final isValidated =
                context.read<ChangePinValidationCubit>().isValidated;
            if (isValidated) {
              context.read<ChangePinBloc>().add(ChangePinPressed(
                    oldPin: _oldPinTec.text,
                    newPin: _newPinTec.text,
                    newPinConfirmation: _newPinConfirmationTec.text,
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
              BlocBuilder<ChangePinValidationCubit, ChangePinValidationState>(
                builder: (context, state) {
                  return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        title: t.lblOldPin,
                        titleColor: clrBackgroundBlack.withOpacity(0.75),
                        controller: _oldPinTec,
                        focusNode: _oldPinFocus,
                        hintText: 'Masukkan PIN lama..',
                        onFieldSubmitted: (_) {
                          _newPinFocus.requestFocus();
                        },
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        isError: (state.oldPinError ?? '').isNotEmpty,
                        errorText: state.oldPinError,
                        isDarkMode: false,
                        textInputType: TextInputType.number,
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
                              .read<ChangePinValidationCubit>()
                              .validateOldPin(t, _oldPinTec.text);
                        },
                        obsecureText: obsecureState.isOldPassword,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              BlocBuilder<ChangePinValidationCubit, ChangePinValidationState>(
                  builder: (context, state) {
                return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                  builder: (context, obsecureState) {
                    return MainTextField(
                      title: t.lblNewPin,
                      titleColor: clrBackgroundBlack.withOpacity(0.75),
                      controller: _newPinTec,
                      focusNode: _newPinFocus,
                      hintText: 'Masukkan PIN baru..',
                      onFieldSubmitted: (_) {
                        _newPinConfirmarionFocus.requestFocus();
                      },
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      isError: (state.newPinError ?? '').isNotEmpty,
                      errorText: state.newPinError,
                      isDarkMode: false,
                      textInputType: TextInputType.number,
                      suffixIcon: IconButton(
                        onPressed: () => context
                            .read<ChangeObsecureCubit>()
                            .changeObsNewPassword(!obsecureState.isNewPassword),
                        icon: Icon(
                          obsecureState.isNewPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: clrNeutralGrey999.withOpacity(0.5),
                        ),
                      ),
                      onChange: (value) {
                        context.read<ChangePinValidationCubit>().validateNewPin(
                            t, _newPinTec.text, _newPinConfirmationTec.text);
                      },
                      obsecureText: obsecureState.isNewPassword,
                    );
                  },
                );
              }),
              const SizedBox(height: 18),
              BlocBuilder<ChangePinValidationCubit, ChangePinValidationState>(
                  builder: (context, state) {
                return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                  builder: (context, obsecureState) {
                    return MainTextField(
                      title: t.lblNewPinConfirmation,
                      titleColor: clrBackgroundBlack.withOpacity(0.75),
                      controller: _newPinConfirmationTec,
                      focusNode: _newPinConfirmarionFocus,
                      hintText: 'Masukkan ulang PIN baru..',
                      onFieldSubmitted: (_) {
                        // _dobFocus.requestFocus();
                      },
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      isError: (state.newPinConfirmError ?? '').isNotEmpty,
                      errorText: state.newPinConfirmError,
                      isDarkMode: false,
                      textInputType: TextInputType.number,
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
                            .read<ChangePinValidationCubit>()
                            .validateNewPinConfirm(t, _newPinTec.text,
                                _newPinConfirmationTec.text);
                      },
                      obsecureText: obsecureState.isConfirmPassword,
                    );
                  },
                );
              }),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
