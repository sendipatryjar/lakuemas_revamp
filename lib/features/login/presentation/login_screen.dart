import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import 'blocs/login/login_bloc.dart';
import 'cubits/password_obsecure/password_obsecure_cubit.dart';
import 'widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<LoginBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<PasswordObsecureCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: clrBackgroundBlack,
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: const Text(
        //     'Login',
        //     style: TextStyle(
        //       fontSize: 16,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),
        // resizeToAvoidBottomInset: false,
        bottomNavigationBar: LoginFormWidget(
          height: MediaQuery.of(context).size.height * 0.8,
        ),
        body: SafeArea(child: Center(child: Image.asset(imgLogo))),
      ),
    );
  }
}
