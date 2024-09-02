class SendOtpReq {
  final String username;
  final int otpType;

  SendOtpReq({required this.username, required this.otpType});

  static SendOtpReq fromJson(Map<String, dynamic> json) => SendOtpReq(
        username: json['username'],
        otpType: json['otp_type'],
      );

  Map<String, Object?> toJson() => {
        'username': username,
        'otp_type': otpType,
      };
}
