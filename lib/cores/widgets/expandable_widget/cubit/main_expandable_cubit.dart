import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_expandable_state.dart';

class MainExpandableCubit extends Cubit<MainExpandableState> {
  MainExpandableCubit() : super(const MainExpandableState(isExpanded: false));

  void changeExpanded(bool value) =>
      emit(MainExpandableState(isExpanded: value));
}
