import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/chart_duration_entity.dart';
import '../../../domain/usecases/get_chart_uc.dart';

part 'get_chart_event.dart';
part 'get_chart_state.dart';

class GetChartBloc extends Bloc<GetChartEvent, GetChartState> {
  final GetChartUc getChartUc;

  GetChartBloc({required this.getChartUc}) : super(GetChartInitialState()) {
    on<GetChartNowEvent>((event, emit) async {
      emit(GetChartLoadingState());
      final result = await getChartUc();
      result.fold(
        (l) => emit(GetChartFailureState(l, l.code, l.messages)),
        (r) => emit(GetChartSuccessState(r)),
      );
    });
  }
}
