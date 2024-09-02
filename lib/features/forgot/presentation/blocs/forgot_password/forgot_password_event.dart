part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordPressedEvent extends ForgotPasswordEvent {
  final String newPassword;
  final String confirmPassword;

  const ForgotPasswordPressedEvent(
    this.newPassword,
    this.confirmPassword,
  );

  @override
  List<Object> get props => [newPassword, confirmPassword];
}
