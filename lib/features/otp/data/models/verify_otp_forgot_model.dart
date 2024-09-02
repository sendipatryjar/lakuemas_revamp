import 'package:equatable/equatable.dart';

class VerifyOtpForgotModel extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final int? exp;
  final int? iat;

  const VerifyOtpForgotModel({
    this.accessToken,
    this.refreshToken,
    this.exp,
    this.iat,
  });

  @override
  List<Object?> get props => [
        [accessToken, refreshToken, exp, iat]
      ];

  static VerifyOtpForgotModel fromJson(Map<String, dynamic> json) =>
      VerifyOtpForgotModel(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        exp: json['exp'],
        iat: json['iat'],
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'exp': exp,
        'iat': iat,
      };
}
