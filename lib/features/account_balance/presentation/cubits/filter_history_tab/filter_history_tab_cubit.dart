import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_history_tab_state.dart';

class FilterHistoryTabCubit extends Cubit<FilterHistoryTabState> {
  FilterHistoryTabCubit()
      : super(const FilterHistoryTabState(
            enFilterPeriod: EnFilterPeriod.sevenDays));

  void changeFilter(EnFilterPeriod enFilterPeriod) => emit(state.copyWith(
        enFilterPeriod: enFilterPeriod,
      ));
}
