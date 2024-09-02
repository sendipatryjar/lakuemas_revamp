part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class OtpSendPressed extends OtpEvent {
  final String username;
  final int otpType;

  /// [otpLocation] is between 0 for login, 1 for register, 2 for forgot pin
  final int otpLocation;

  const OtpSendPressed({
    required this.username,
    required this.otpType,
    required this.otpLocation,
  });

  @override
  List<Object> get props => [
        username,
        otpType,
        otpLocation,
      ];
}

class OtpReSendPressed extends OtpEvent {
  final String username;
  final int otpType;

  /// [otpLocation] is between 0 for login and 1 for register
  final int otpLocation;

  const OtpReSendPressed({
    required this.username,
    required this.otpType,
    required this.otpLocation,
  });

  @override
  List<Object> get props => [username, otpType, otpLocation];
}

class OtpVerifyPressed extends OtpEvent {
  final String username;
  final String otpCode;
  final int? otpType;
  final String? privyId;

  /// [otpLocation] is between 0 for login, 1 for register, 2 for account verification
  final int otpLocation;

  const OtpVerifyPressed({
    required this.username,
    required this.otpCode,
    required this.otpType,
    this.privyId,
    required this.otpLocation,
  });

  @override
  List<Object> get props => [
        username,
        otpCode,
        [otpType, privyId],
        otpLocation
      ];
}
