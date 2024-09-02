import 'package:equatable/equatable.dart';

class VerifyOtpLoginModel extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final int? customerId;
  final bool? pinStatus;

  const VerifyOtpLoginModel(
      {this.accessToken, this.refreshToken, this.customerId, this.pinStatus});

  @override
  List<Object?> get props => [
        [accessToken, refreshToken, customerId, pinStatus]
      ];

  static VerifyOtpLoginModel fromJson(Map<String, dynamic> json) =>
      VerifyOtpLoginModel(
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        customerId: json['customer_id'],
        pinStatus: json['pin_status'],
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'customer_id': customerId,
        'pin_status': pinStatus,
      };
}
