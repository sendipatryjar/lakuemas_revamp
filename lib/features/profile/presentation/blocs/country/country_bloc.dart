import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/country_entity.dart';
import '../../../domain/usecases/get_countries_uc.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final GetCountriesUc getCountriesUc;

  CountryBloc({required this.getCountriesUc}) : super(CountryInitialState()) {
    on<CountryGetEvent>((event, emit) async {
      emit(CountryLoadingState());
      final result = await getCountriesUc(GetCountriesParams(
        limit: event.limit ?? 100,
        page: event.page ?? 1,
        sortBy: event.sortBy ?? 'asc',
      ));
      result.fold(
        (l) => emit(CountryFailureState(l, l.code, l.messages)),
        (r) => emit(CountrySuccessState(r)),
      );
    });
  }
}
