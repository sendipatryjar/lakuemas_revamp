// part of 'otp_pin_bloc.dart';

// enum OtpForgotPin { send, resend, verify }

// sealed class OtpPinState extends Equatable {
//   const OtpPinState();

//   @override
//   List<Object> get props => [];
// }

// final class OtpPinInitial extends OtpPinState {}

// final class OtpPinLoading extends OtpPinState {}

// final class OtpPinSuccess extends OtpPinState {
//   final int? otpType;
//   final OtpForgotPin otp;

//   const OtpPinSuccess({this.otpType, required this.otp});

//   @override
//   List<Object> get props => [
//         [otpType, otp]
//       ];
// }

// final class OtpPinFailure extends OtpPinState {
//   final int? code;
//   final String? message;

//   const OtpPinFailure(this.code, this.message);

//   @override
//   List<Object> get props => [
//         [code, message]
//       ];
// }
