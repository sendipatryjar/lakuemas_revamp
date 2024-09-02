part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginPressed extends LoginEvent {
  final BuildContext context;
  final String? emailOrPhone;
  final String? password;

  const LoginPressed(this.context, this.emailOrPhone, this.password);

  @override
  List<Object> get props => [
        {context, emailOrPhone, password}
      ];
}

class LoginPrivyPressed extends LoginEvent {
  final BuildContext context;
  final String? code;

  const LoginPrivyPressed(this.context, this.code);

  @override
  List<Object> get props => [
        {context, code}
      ];
}

class InitialChange extends LoginEvent {}
