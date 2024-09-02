import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/mutation_entity.dart';
import '../../../domain/usecases/get_mutations_uc.dart';

part 'mutation_event.dart';
part 'mutation_state.dart';

class MutationBloc extends Bloc<MutationEvent, MutationState> {
  final GetMutationsUc getMutationsUc;

  MutationBloc({required this.getMutationsUc}) : super(MutationInitialState()) {
    on<MutationGetEvent>((event, emit) async {
      emit(MutationLoadingState());
      final result = await getMutationsUc(
        status: event.status,
        period: event.period,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      result.fold(
        (l) => emit(MutationFailureState(l, l.code, l.messages)),
        (r) => emit(MutationSuccessState(mutation: r)),
      );
    });
  }
}
