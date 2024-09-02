import '../../domain/entities/login_entity.dart';

class LoginModelField {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String phoneNumber = 'phone_number';
  static const String email = 'email';
  static const String privyId = 'privy_id';
}

class LoginModel extends LoginEntity {
  const LoginModel({
    String? accessToken,
    String? refreshToken,
    String? phoneNumber,
    String? email,
    String? privyId,
  }) : super(
          accessToken: accessToken,
          refreshToken: refreshToken,
          phoneNumber: phoneNumber,
          email: email,
          privyId: privyId,
        );

  Map<String, Object?> toJson() => {
        LoginModelField.accessToken: accessToken,
        LoginModelField.refreshToken: refreshToken,
        LoginModelField.phoneNumber: phoneNumber,
        LoginModelField.email: email,
        LoginModelField.privyId: privyId,
      };

  LoginModel copy({
    String? accessToken,
    String? refreshToken,
    String? phoneNumber,
    String? email,
    String? privyId,
  }) =>
      LoginModel(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        privyId: privyId ?? this.privyId,
      );

  static LoginModel fromJson(Map<String, Object?> json) => LoginModel(
      accessToken: json[LoginModelField.accessToken] as String?,
      refreshToken: json[LoginModelField.refreshToken] as String?,
      phoneNumber: json[LoginModelField.phoneNumber] as String?,
      email: json[LoginModelField.email] as String?,
      privyId: json[LoginModelField.privyId] as String?);
}
