part of 'otp_forgot_bloc.dart';

sealed class OtpForgotEvent extends Equatable {
  const OtpForgotEvent();

  @override
  List<Object> get props => [];
}

class OtpSendPressed extends OtpForgotEvent {
  final String username;
  final int otpType;

  const OtpSendPressed({
    required this.username,
    required this.otpType,
  });

  @override
  List<Object> get props => [username, otpType];
}

class OtpReSendPressed extends OtpForgotEvent {
  final String username;
  final int otpType;

  const OtpReSendPressed({
    required this.username,
    required this.otpType,
  });

  @override
  List<Object> get props => [username, otpType];
}

class OtpVerifyPressed extends OtpForgotEvent {
  final String username;
  final String otpCode;
  final int? otpType;

  const OtpVerifyPressed({
    required this.username,
    required this.otpCode,
    required this.otpType,
  });

  @override
  List<Object> get props => [
        username,
        otpCode,
        [otpType],
      ];
}
