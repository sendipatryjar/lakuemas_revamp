import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/get_banks_entity.dart';
import '../../../domain/usecases/get_banks_uc.dart';
part 'get_banks_event.dart';
part 'get_banks_state.dart';

class GetBanksBloc extends Bloc<GetBanksEvent, GetBanksState> {
  final GetBanksUc getBanksUc;
  GetBanksBloc({required this.getBanksUc}) : super(GetBanksInitial()) {
    on<BankAccountGetEvent>((event, emit) async {
      emit(GetBanksLoadingState());
      final result = await getBanksUc(BankAccountParams(
          limit: event.limit ?? 100,
          page: event.page ?? 1,
          sortBy: event.sortBy ?? 'asc'));
      result.fold(
        (l) => emit(GetBanksFailureState(l, l.code, l.messages)),
        (r) => emit(GetBanksSuccessState(r)),
      );
    });
  }
}
