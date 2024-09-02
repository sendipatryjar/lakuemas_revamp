import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/district_entity.dart';
import '../../../domain/usecases/get_districts_uc.dart';

part 'district_event.dart';
part 'district_state.dart';

class DistrictBloc extends Bloc<DistrictEvent, DistrictState> {
  final GetDistrictsUc getDistrictsUc;
  DistrictBloc({required this.getDistrictsUc}) : super(DistrictInitialState()) {
    on<DistrictGetEvent>((event, emit) async {
      emit(DistrictLoadingState());
      final result = await getDistrictsUc(GetDistrictsParams(
        limit: event.limit ?? 100,
        page: event.page ?? 1,
        cityId: event.cityId,
        sortBy: event.sortBy ?? 'asc',
        orderBy: event.orderBy,
      ));
      result.fold(
        (l) => emit(DistrictFailureState(l, l.code, l.messages)),
        (r) => emit(DistrictSuccessState(r)),
      );
    });
    on<DistrictBackToInitEvent>((event, emit) => emit(DistrictInitialState()));
  }
}
