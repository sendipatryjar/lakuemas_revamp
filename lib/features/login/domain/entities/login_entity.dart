import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final String? email;
  final String? phoneNumber;
  final String? privyId;

  const LoginEntity({
    this.accessToken,
    this.refreshToken,
    this.email,
    this.phoneNumber,
    this.privyId,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        email,
        phoneNumber,
        privyId,
      ];
}
