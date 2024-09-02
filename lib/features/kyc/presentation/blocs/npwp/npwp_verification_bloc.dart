import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/npwp_verification_uc.dart';

part 'npwp_verification_event.dart';
part 'npwp_verification_state.dart';

class NpwpVerificationBloc
    extends Bloc<NpwpVerificationEvent, NpwpVerificationState> {
  final NpwpVerificationUc npwpVerificationUc;

  NpwpVerificationBloc({
    required this.npwpVerificationUc,
  }) : super(NpwpVerificationInitialState()) {
    on<NpwpVerificationPressedEvent>((event, emit) async {
      emit(NpwpVerificationLoadingState());
      final result =
          await npwpVerificationUc(event.npwpNo, event.npwpPhotoBytes);

      result.fold(
        (l) => emit(NpwpVerificationFailureState(l.code, l.messages)),
        (r) => emit(NpwpVerificationSuccessState()),
      );
    });
  }
}
