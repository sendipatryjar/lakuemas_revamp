// part of 'otp_pin_bloc.dart';

// sealed class OtpPinEvent extends Equatable {
//   const OtpPinEvent();

//   @override
//   List<Object> get props => [];
// }

// class OtpSendPressed extends OtpPinEvent {
//   final String username;
//   final int otpType;

//   const OtpSendPressed({
//     required this.username,
//     required this.otpType,
//   });

//   @override
//   List<Object> get props => [username, otpType];
// }

// class OtpReSendPressed extends OtpPinEvent {
//   final String username;
//   final int otpType;

//   const OtpReSendPressed({
//     required this.username,
//     required this.otpType,
//   });

//   @override
//   List<Object> get props => [username, otpType];
// }

// class OtpVerifyPressed extends OtpPinEvent {
//   final String username;
//   final String otpCode;
//   final int? otpType;

//   const OtpVerifyPressed({
//     required this.username,
//     required this.otpCode,
//     required this.otpType,
//   });

//   @override
//   List<Object> get props => [
//         username,
//         otpCode,
//         [otpType],
//       ];
// }
