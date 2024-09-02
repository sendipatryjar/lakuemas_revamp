import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/kyc_selfie_uc.dart';

part 'kyc_selfie_event.dart';
part 'kyc_selfie_state.dart';

class KycSelfieBloc extends Bloc<KycSelfieEvent, KycSelfieState> {
  final KycSelfieUc kycSelfieUc;
  KycSelfieBloc({required this.kycSelfieUc}) : super(KycSelfieInitial()) {
    on<KycSelfiePressed>((event, emit) async {
      emit(KycSelfieLoadingState());
      final result = await kycSelfieUc(event.selfiePhotoBytes);
      result.fold(
        (l) => emit(KycSelfieFailureState(l, l.code, l.messages)),
        (r) => emit(const KycSelfieSuccessState()),
      );
    });
  }
}
