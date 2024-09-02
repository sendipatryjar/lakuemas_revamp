import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_date_state.dart';

class FilterDateCubit extends Cubit<FilterDateState> {
  FilterDateCubit() : super(const FilterDateState());

  void pickDate(List<DateTime?>? date) {
    emit(state.copyWith(date: date));
  }
}
