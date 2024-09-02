import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/province_entity.dart';
import '../../../domain/usecases/get_provinces_uc.dart';

part 'province_event.dart';
part 'province_state.dart';

class ProvinceBloc extends Bloc<ProvinceEvent, ProvinceState> {
  final GetProvincesUc getProvincesUc;
  ProvinceBloc({required this.getProvincesUc}) : super(ProvinceInitialState()) {
    on<ProvinceGetEvent>((event, emit) async {
      emit(ProvinceLoadingState());
      final result = await getProvincesUc(GetProvincesParams(
        limit: event.limit ?? 100,
        page: event.page ?? 1,
        sortBy: event.sortBy ?? 'asc',
        orderBy: event.orderBy ?? 'name',
      ));
      result.fold(
        (l) => emit(ProvinceFailureState(l, l.code, l.messages)),
        (r) => emit(ProvinceSuccessState(r)),
      );
    });
  }
}
