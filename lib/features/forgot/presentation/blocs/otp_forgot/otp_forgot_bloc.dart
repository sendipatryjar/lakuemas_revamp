import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/send_otp_forgot_uc.dart';
import '../../../domain/usecases/verify_otp_forgot_uc.dart';

part 'otp_forgot_event.dart';
part 'otp_forgot_state.dart';

class OtpForgotBloc extends Bloc<OtpForgotEvent, OtpForgotState> {
  final SendOtpForgotUc sendOtpForgotUc;
  final VerifyOtpForgotUc verifyOtpForgotUc;

  OtpForgotBloc({
    required this.sendOtpForgotUc,
    required this.verifyOtpForgotUc,
  }) : super(OtpForgotInitial()) {
    on<OtpSendPressed>((event, emit) async {
      emit(OtpForgotLoading());
      final result = await sendOtpForgotUc(SendOtpParams(
        username: event.username,
        otpType: event.otpType,
      ));
      result.fold(
        (l) => emit(OtpForgotFailure(l.code, l.messages)),
        (r) =>
            emit(OtpForgotSuccess(otpType: event.otpType, otp: OtpForgot.send)),
      );
    });

    on<OtpReSendPressed>((event, emit) async {
      emit(OtpForgotLoading());
      final result = await sendOtpForgotUc(SendOtpParams(
        username: event.username,
        otpType: event.otpType,
      ));
      result.fold(
        (l) => emit(OtpForgotFailure(l.code, l.messages)),
        (r) => emit(
            OtpForgotSuccess(otpType: event.otpType, otp: OtpForgot.resend)),
      );
    });

    on<OtpVerifyPressed>((event, emit) async {
      emit(OtpForgotLoading());
      final result = await verifyOtpForgotUc(VerifyOtpParams(
        username: event.username,
        otpCode: event.otpCode,
        otpType: event.otpType,
      ));
      result.fold(
        (l) => emit(OtpForgotFailure(l.code, l.messages)),
        (r) => emit(const OtpForgotSuccess(otp: OtpForgot.verify)),
      );
    });
  }
}
