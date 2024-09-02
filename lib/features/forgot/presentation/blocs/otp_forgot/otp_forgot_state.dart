part of 'otp_forgot_bloc.dart';

enum OtpForgot { send, resend, verify }

sealed class OtpForgotState extends Equatable {
  const OtpForgotState();

  @override
  List<Object> get props => [];
}

final class OtpForgotInitial extends OtpForgotState {}

final class OtpForgotLoading extends OtpForgotState {}

final class OtpForgotSuccess extends OtpForgotState {
  final int? otpType;
  final OtpForgot otp;

  const OtpForgotSuccess({this.otpType, required this.otp});

  @override
  List<Object> get props => [
        [otpType, otp]
      ];
}

final class OtpForgotFailure extends OtpForgotState {
  final int? code;
  final String? message;

  const OtpForgotFailure(this.code, this.message);

  @override
  List<Object> get props => [
        [code, message]
      ];
}
