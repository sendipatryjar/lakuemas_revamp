import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/utils/validation_utils.dart';
import '../../../domain/usecases/login_privy_uc.dart';
import '../../../domain/usecases/login_uc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUc loginUc;
  final LoginPrivyUc loginPrivyUc;

  LoginBloc({required this.loginUc, required this.loginPrivyUc})
      : super(LoginInitial()) {
    on<LoginPressed>((event, emit) async {
      emit(LoginLoading());
      final t = AppLocalizations.of(event.context)!;
      Map<String, dynamic> errors = {};
      if ((event.emailOrPhone ?? '').isEmpty) {
        errors['username'] =
            '${t.lblEmail} ${t.lblOr} ${t.lblPhoneNumber} ${t.lblCantBeEmpty}';
      }
      bool isPhoneValid = ValidationUtils.mobilePhone(event.emailOrPhone ?? '');
      bool isEmailValid = ValidationUtils.email(event.emailOrPhone ?? '');
      if (isEmailValid == false &&
          isPhoneValid == false &&
          (event.emailOrPhone ?? '').isNotEmpty) {
        errors['username'] =
            '${t.lblEmail} ${t.lblOr} ${t.lblPhoneNumber} ${t.lblNotValid}';
      }
      if ((event.password ?? '').isEmpty) {
        errors['password'] = '${t.lblPassword} ${t.lblCantBeEmpty}';
      }
      bool isPasswordValid = ValidationUtils.password(event.password ?? '');
      if (isPasswordValid == false && (event.password ?? '').isNotEmpty) {
        errors['password'] = '${t.lblPassword} minimal 6 karakter';
      }

      if (errors.isNotEmpty) {
        // emit(const LoginFailure(ClientFailure(code: 500), 500, null));
        emit(LoginFailure(MobileValidationFailure(errors: errors), null, null));
        return;
      }

      final result = await loginUc(LoginParams(
        userName: event.emailOrPhone ?? '',
        password: event.password ?? '',
      ));
      result.fold((l) {
        emit(LoginFailure(l, l.code, l.messages));
      }, (r) {
        emit(LoginSuccess(
          email: r.email,
          phoneNumber: r.phoneNumber,
          isPrivyRegister: false,
        ));
      });
    });

    on<LoginPrivyPressed>((event, emit) async {
      emit(LoginLoading());
      // final t = AppLocalizations.of(event.context)!;
      final result = await loginPrivyUc(code: event.code);
      result.fold(
        (l) {
          emit(LoginFailure(l, l.code, l.messages));
        },
        (r) {
          emit(
            LoginSuccess(
              email: r.email,
              phoneNumber: r.phoneNumber,
              isPrivyRegister: ((r.accessToken ?? '').isEmpty &&
                  (r.refreshToken ?? '').isEmpty),
              privyId: r.privyId,
            ),
          );
        },
      );
    });

    on<InitialChange>((event, emit) {
      emit(LoginInitial());
    });
  }
}
