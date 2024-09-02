import 'package:flutter_bloc/flutter_bloc.dart';

class LakusaveAutoExtendedCubit extends Cubit<int> {
  LakusaveAutoExtendedCubit() : super(0);

  void change(int value) => emit(value);
}
