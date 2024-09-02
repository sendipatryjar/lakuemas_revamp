import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/city_entity.dart';
import '../../../domain/usecases/get_cities_uc.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final GetCitiesUc getCitiesUc;
  CityBloc({required this.getCitiesUc}) : super(CityInitialState()) {
    on<CityGetEvent>((event, emit) async {
      emit(CityLoadingState());
      final result = await getCitiesUc(GetCitiesParams(
        limit: event.limit ?? 100,
        page: event.page ?? 1,
        provinceId: event.provinceId,
        sortBy: event.sortBy ?? 'asc',
        orderBy: event.orderBy ?? 'city',
        keyword: event.keyword,
      ));
      result.fold(
        (l) => emit(CityFailureState(l, l.code, l.messages)),
        (r) => emit(CitySuccessState(r)),
      );
    });
    on<CityBackToInitEvent>((event, emit) => emit(CityInitialState()));
  }
}
