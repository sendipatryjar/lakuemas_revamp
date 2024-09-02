// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../domain/usecases/send_otp_forgot_pin_uc.dart';
// import '../../../domain/usecases/verify_otp_forgot_pin_uc.dart';

// part 'otp_pin_event.dart';
// part 'otp_pin_state.dart';

// class OtpPinBloc extends Bloc<OtpPinEvent, OtpPinState> {
//   final SendOtpForgotPinUc sendOtpForgotPinUc;
//   final VerifyOtpForgotPinUc verifyOtpForgotPinUc;

//   OtpPinBloc({
//     required this.sendOtpForgotPinUc,
//     required this.verifyOtpForgotPinUc,
//   }) : super(OtpPinInitial()) {
//     on<OtpSendPressed>((event, emit) async {
//       emit(OtpPinLoading());
//       final result = await sendOtpForgotPinUc(SendOtpParams(
//         username: event.username,
//         otpType: event.otpType,
//       ));
//       result.fold(
//         (l) => emit(OtpPinFailure(l.code, l.messages)),
//         (r) =>
//             emit(OtpPinSuccess(otpType: event.otpType, otp: OtpForgotPin.send)),
//       );
//     });

//     on<OtpReSendPressed>((event, emit) async {
//       emit(OtpPinLoading());
//       final result = await sendOtpForgotPinUc(SendOtpParams(
//         username: event.username,
//         otpType: event.otpType,
//       ));
//       result.fold(
//         (l) => emit(OtpPinFailure(l.code, l.messages)),
//         (r) => emit(
//             OtpPinSuccess(otpType: event.otpType, otp: OtpForgotPin.resend)),
//       );
//     });

//     on<OtpVerifyPressed>((event, emit) async {
//       emit(OtpPinLoading());
//       final result = await verifyOtpForgotPinUc(VerifyOtpParams(
//         username: event.username,
//         otpCode: event.otpCode,
//         otpType: event.otpType,
//       ));
//       result.fold(
//         (l) => emit(OtpPinFailure(l.code, l.messages)),
//         (r) => emit(const OtpPinSuccess(otp: OtpForgotPin.verify)),
//       );
//     });
//   }
// }
