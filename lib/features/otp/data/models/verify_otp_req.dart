class VerifyOtpReq {
  final String username;
  final String otpCode;
  final int? otpType;
  final String? privyId;

  VerifyOtpReq({
    required this.username,
    required this.otpCode,
    required this.otpType,
    this.privyId,
  });

  static VerifyOtpReq fromJson(Map<String, dynamic> json) => VerifyOtpReq(
        username: json['username'],
        otpCode: json['otp_code'],
        otpType: json['otp_type'],
        privyId: json['privy_id'],
      );

  Map<String, Object?> toJson() => {
        'username': username,
        'otp_code': otpCode,
        'otp_type': otpType,
        'privy_id': privyId,
      };
}
