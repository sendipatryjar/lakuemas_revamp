import 'package:equatable/equatable.dart';

class ChangePasswordReq extends Equatable {
  final String? oldPassword;
  final String? newPassword;
  final String? confirmPassword;

  const ChangePasswordReq(
      {this.oldPassword, this.newPassword, this.confirmPassword});

  factory ChangePasswordReq.fromJson(Map<String, dynamic> json) {
    return ChangePasswordReq(
      oldPassword: json['old_password'],
      newPassword: json['new_password'],
      confirmPassword: json['confirm_password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['old_password'] = oldPassword;
    data['new_password'] = newPassword;
    data['confirm_password'] = confirmPassword;
    return data;
  }

  @override
  List<Object?> get props => [oldPassword, newPassword, confirmPassword];
}
