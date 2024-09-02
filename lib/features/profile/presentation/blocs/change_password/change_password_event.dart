part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordPressed extends ChangePasswordEvent {
  final String? oldPassword;
  final String? newPassword;
  final String? newPasswordConfirmation;

  const ChangePasswordPressed({
    this.oldPassword,
    this.newPassword,
    this.newPasswordConfirmation,
  });

  @override
  List<Object> get props => [
        [oldPassword, newPassword, newPasswordConfirmation]
      ];
}
