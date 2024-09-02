import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/unsub_elite_uc.dart';

part 'unsub_elite_event.dart';
part 'unsub_elite_state.dart';

class UnsubEliteBloc extends Bloc<UnsubEliteEvent, UnsubEliteState> {
  final UnsubEliteUc unsubEliteUc;

  UnsubEliteBloc({required this.unsubEliteUc}) : super(UnsubEliteInitial()) {
    on<UnsubElitePostEvent>((event, emit) async {
      emit(UnsubEliteLoadingState());
      final result = await unsubEliteUc(
        reason: event.reason,
      );
      result.fold(
        (l) => emit(UnsubEliteFailureState(l, l.code, l.messages)),
        (r) => emit(UnsubEliteSuccessState()),
      );
    });
  }
}
