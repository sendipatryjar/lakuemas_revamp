import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/kyc_ktp_uc.dart';

part 'kyc_ktp_event.dart';
part 'kyc_ktp_state.dart';

class KycKtpBloc extends Bloc<KycKtpEvent, KycKtpState> {
  final KycKtpUc kycKtpUc;
  KycKtpBloc({required this.kycKtpUc}) : super(KycKtpInitial()) {
    on<KycKtpPressed>((event, emit) async {
      emit(KycKtpLoadingState());
      if ((event.nik ?? '').length != 16) {
        emit(KycKtpFailureValidateState(event.t.lblNikMustBe16Digits));
        return;
      }
      final result = await kycKtpUc(KycKtpParams(
        nik: event.nik,
        name: event.name,
        pob: event.pob,
        dob: event.dob,
        ktpPhotoBytes: event.ktpPhoto,
      ));
      result.fold(
        (l) => emit(KycKtpFailureState(l, l.code, l.messages)),
        (r) => emit(const KycKtpSuccessState()),
      );
    });
  }
}
