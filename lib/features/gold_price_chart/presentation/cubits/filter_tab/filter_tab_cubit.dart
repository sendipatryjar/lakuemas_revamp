import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_tab_state.dart';

class FilterTabCubit extends Cubit<FilterTabState> {
  FilterTabCubit()
      : super(const FilterTabState(enFilteredTab: EnFilteredTab.sevenDays));

  List<Map<String, dynamic>> get durations => [
        {
          'title': '7 Hari',
          'enFilteredTab': EnFilteredTab.sevenDays,
        },
        {
          'title': '1 Bulan',
          'enFilteredTab': EnFilteredTab.oneMonth,
        },
        {
          'title': '3 Bulan',
          'enFilteredTab': EnFilteredTab.thirdMonth,
        },
        {
          'title': '6 Bulan',
          'enFilteredTab': EnFilteredTab.sixMonth,
        },
      ];

  void changeFilterTab(EnFilteredTab enFilteredTab) =>
      emit(state.copyWith(enFilteredTab: enFilteredTab));
}
