import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/generate_liveness_url_uc.dart';

part 'liveness_event.dart';
part 'liveness_state.dart';

class LivenessBloc extends Bloc<LivenessEvent, LivenessState> {
  final GenerateLivenessUrlUc generateLivenessUrlUc;

  LivenessBloc({required this.generateLivenessUrlUc})
      : super(LivenessInitial()) {
    on<LivenessGenerateUrlEvent>((event, emit) async {
      emit(LivenessLoadingState());
      final result = await generateLivenessUrlUc();
      result.fold(
        (l) => emit(LivenessFailureState(l, l.code, l.messages)),
        (r) => emit(LivenessSuccessState(url: r)),
      );
    });
  }
}
