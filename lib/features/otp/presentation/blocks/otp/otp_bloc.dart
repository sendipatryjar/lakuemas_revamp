import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/send_otp_uc.dart';
import '../../../domain/usecases/verify_otp_uc.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final SendOtpUc sendOtpUc;
  final VerifyOtpUc verifyOtpUc;

  OtpBloc({
    required this.sendOtpUc,
    required this.verifyOtpUc,
  }) : super(OtpInitial()) {
    on<OtpSendPressed>((event, emit) async {
      emit(OtpLoading());
      final result = await sendOtpUc(SendOtpParams(
        username: event.username,
        otpType: event.otpType,
        otpLocation: event.otpLocation,
      ));
      result.fold(
        (l) => emit(OtpFailure(l.code, l.messages)),
        (r) => emit(OtpSuccess(
          otpType: event.otpType,
          otp: Otp.send,
        )),
      );
    });

    on<OtpReSendPressed>((event, emit) async {
      emit(OtpLoading());
      final result = await sendOtpUc(SendOtpParams(
        username: event.username,
        otpType: event.otpType,
        otpLocation: event.otpLocation,
      ));
      result.fold(
        (l) => emit(OtpFailure(l.code, l.messages)),
        (r) => emit(OtpSuccess(otpType: event.otpType, otp: Otp.resend)),
      );
    });

    on<OtpVerifyPressed>((event, emit) async {
      emit(OtpLoading());
      final result = await verifyOtpUc(VerifyOtpParams(
        username: event.username,
        otpCode: event.otpCode,
        otpType: event.otpType,
        otpLocation: event.otpLocation,
        privyId: event.privyId,
      ));
      result.fold(
        (l) => emit(OtpFailure(l.code, l.messages)),
        (r) => emit(OtpSuccess(otp: Otp.verify, pinStatus: r)),
      );
    });
  }
}
