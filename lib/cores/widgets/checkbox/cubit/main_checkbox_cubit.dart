import 'package:flutter_bloc/flutter_bloc.dart';

class MainCheckboxCubit extends Cubit<bool> {
  MainCheckboxCubit() : super(false);

  void initValue(bool value) => emit(value);
  void toggle() => emit(!state);
}
