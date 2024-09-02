import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../login/presentation/cubits/password_obsecure/password_obsecure_cubit.dart';
import 'blocs/pivacy_policy_register/privacy_policy_register_bloc.dart';
import 'blocs/register/register_bloc.dart';
import 'blocs/t_and_c_register/t_and_c_register_bloc.dart';
import 'cubits/register_validation/register_validation_cubit.dart';
import 'widgets/register_form_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PasswordObsecureCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<RegisterValidationCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<RegisterBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              sl<TAndCRegisterBloc>()..add(TAndCRegisterGetEvent()),
        ),
        BlocProvider(
          create: (context) => sl<PrivacyPolicyRegisterBloc>()
            ..add(PrivacyPolicyRegisterGetEvent()),
        ),
      ],
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            EasyLoading.show();
          }
          if (state is RegisterSuccess) {
            EasyLoading.dismiss();
            context.goNamed(
              AppRoutes.otpChooseRegister,
              extra: {
                'parentScreenName': AppRoutes.register,
                'phoneNumber': state.registerEntity.phoneNumber,
                'email': state.registerEntity.email,
              },
            );
          }
          if (state is RegisterFailure) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(key: key, t: t),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    super.key,
    required this.t,
  });

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrBackgroundBlack,
      appBar: AppBar(
        centerTitle: true,
        title: Text(t.lblRegister,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.login);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: RegisterFormWidget(),
      ),
    );
  }
}
