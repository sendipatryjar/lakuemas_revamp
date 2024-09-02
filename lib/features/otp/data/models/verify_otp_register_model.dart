import 'package:equatable/equatable.dart';

class VerifyOtpRegisterModel extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final int? customerId;

  const VerifyOtpRegisterModel(
      {this.accessToken, this.refreshToken, this.customerId});

  @override
  List<Object?> get props => [
        [accessToken, refreshToken, customerId]
      ];

  static VerifyOtpRegisterModel fromJson(Map<String, dynamic> json) =>
      VerifyOtpRegisterModel(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        customerId: json['customer_id'],
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'customer_id': customerId,
      };
}
