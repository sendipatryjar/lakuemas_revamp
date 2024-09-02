import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../domain/entities/mutation_entity.dart';
import '../../../domain/usecases/get_mutations_uc.dart';

part 'mutation_onprocess_event.dart';
part 'mutation_onprocess_state.dart';

class MutationOnprocessBloc
    extends Bloc<MutationOnprocessEvent, MutationOnprocessState> {
  final GetMutationsUc getMutationsUc;

  MutationOnprocessBloc({required this.getMutationsUc})
      : super(MutationOnprocessInitialState()) {
    on<MutationOnprocessGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.accBalanceMutations.isNotEmpty) {
        emit(MutationOnprocessSuccessState(
            mutation: event.helperDataCubit.state.accBalanceMutations));
        return;
      }
      emit(MutationOnprocessLoadingState());
      final result = await getMutationsUc(
        status: 0,
        period: null,
        startDate: null,
        endDate: null,
      );
      result.fold(
        (l) => emit(MutationOnprocessFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updateAccBalanceMutations(r);
          emit(MutationOnprocessSuccessState(mutation: r));
        },
      );
    });
  }
}
