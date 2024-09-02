part of 'otp_bloc.dart';

enum Otp { send, resend, verify }

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {
  final int? otpType;
  final Otp otp;
  final bool? pinStatus;

  const OtpSuccess({
    this.otpType,
    required this.otp,
    this.pinStatus,
  });

  @override
  List<Object> get props => [
        [otpType, otp, pinStatus]
      ];
}

class OtpFailure extends OtpState {
  final int? code;
  final String? message;

  const OtpFailure(this.code, this.message);

  @override
  List<Object> get props => [
        [code, message]
      ];
}
