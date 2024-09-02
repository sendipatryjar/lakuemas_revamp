import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/store_entity.dart';
import '../../../domain/usecases/get_store_uc.dart';

part 'stores_event.dart';
part 'stores_state.dart';

class StoresBloc extends Bloc<StoresEvent, StoresState> {
  final GetStoreUc getStoreUc;

  StoresBloc({required this.getStoreUc}) : super(StoresInitial()) {
    on<StoresGetEvent>((event, emit) async {
      emit(StoresLoadingState());
      final result = await getStoreUc(GetStoreParams(
        limit: event.limit ?? 100,
        page: event.page ?? 1,
        cityId: event.cityId,
        sortBy: event.sortBy ?? 'asc',
      ));
      result.fold(
        (l) => emit(StoresFailureState(l, l.code, l.messages)),
        (r) => emit(StoresSuccessState(r)),
      );
    });
    on<StoresBackToInitEvent>((event, emit) => emit(StoresInitial()));
  }
}
