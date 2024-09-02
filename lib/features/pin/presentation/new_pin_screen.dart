import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_text_field.dart';
import '../../forgot/presentation/cubits/change_obsecure/change_obsecure_cubit.dart';
import 'blocs/forgot_pin/forgot_pin_bloc.dart';
import 'cubits/forgot_pin_validation/forgot_pin_validation_cubit.dart';

class NewPinScreen extends StatelessWidget {
  final Map<String, dynamic>? extra;
  const NewPinScreen({
    super.key,
    this.extra = const {},
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController newPinTec = TextEditingController();
    final TextEditingController confirmPinTec = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ForgotPinValidationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ForgotPinBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ChangeObsecureCubit>(),
        ),
      ],
      child: _Content(
        newPinTec: newPinTec,
        confirmPinTec: confirmPinTec,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.newPinTec,
    required this.confirmPinTec,
  });

  final TextEditingController newPinTec;
  final TextEditingController confirmPinTec;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocListener<ForgotPinBloc, ForgotPinState>(
      listener: (context, state) {
        if (state is ForgotPinLoadingState) {
          EasyLoading.show();
        }
        if (state is ForgotPinSuccessState) {
          EasyLoading.dismiss();
          DialogUtils.success(
            context: context,
            barrierDismissible: true,
            firstDesc: 'PIN Barumu Sudah Berhasil Dibuat!',
            secondDesc: 'Silahkan login kembali',
            btnText: 'Kembali ke input PIN',
            btnOnPressed: () {
              context.goNamed(AppRoutes.pin, extra: {
                'pinType': '${PinType.validate}',
                'nextScreenPin': AppRoutes.beranda,
                'backScreenPin': 'null',
              });
            },
          );
          Future.delayed(const Duration(milliseconds: 1500)).then((value) {
            context.goNamed(
              AppRoutes.pin,
              extra: {
                'pinType': '${PinType.validate}',
                'backScreenPin': 'null',
                'nextScreenPin': AppRoutes.beranda,
              },
            );
          });
        }
        if (state is ForgotPinFailureState) {
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
          title: Text(
            'Buat PIN Baru',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
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
          padding: const EdgeInsets.all(20),
          child: MainButton(
            label: 'Buat PIN Baru',
            onPressed: () {
              context.read<ForgotPinValidationCubit>().validatePin(
                    newPinTec.text,
                    confirmPinTec.text,
                  );

              final isValidated =
                  context.read<ForgotPinValidationCubit>().isValidatedPin;

              if (isValidated) {
                context.read<ForgotPinBloc>().add(
                      ForgotPinPressedEvent(
                        newPinTec.text,
                        confirmPinTec.text,
                      ),
                    );
              }
            },
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
              BlocBuilder<ForgotPinValidationCubit, ForgotPinValidationState>(
                builder: (context, state) {
                  return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        controller: newPinTec,
                        title: 'PIN Baru',
                        hintText: 'Terdiri dari 6 Angka',
                        textInputType: TextInputType.number,
                        isError: state.isPinError ?? false,
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        errorText: state.isPinNotSame,
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
                        obsecureText: obsecureState.isNewPassword,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              BlocBuilder<ForgotPinValidationCubit, ForgotPinValidationState>(
                builder: (context, state) {
                  return BlocBuilder<ChangeObsecureCubit, ChangeObsecureState>(
                    builder: (context, obsecureState) {
                      return MainTextField(
                        controller: confirmPinTec,
                        title: 'Tulis Ulang PIN Baru',
                        hintText: 'Terdiri dari 6 Angka',
                        textInputType: TextInputType.number,
                        isError: state.isPinError ?? false,
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        errorText: state.isPinNotSame,
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
