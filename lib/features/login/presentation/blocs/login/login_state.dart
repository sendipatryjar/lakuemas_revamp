part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String? phoneNumber;
  final String? email;
  final bool isPrivyRegister;
  final String? privyId;

  const LoginSuccess({
    required this.phoneNumber,
    required this.email,
    required this.isPrivyRegister,
    this.privyId,
  });

  @override
  List<Object> get props => [
        {phoneNumber, email, isPrivyRegister, privyId}
      ];
}

class LoginFailure extends LoginState {
  final AppFailure? appFailure;
  final int? code;
  final String? message;

  const LoginFailure(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [code, message]
      ];
}
