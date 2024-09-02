import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'fab_state.dart';

class FabCubit extends Cubit<FabState> {
  FabCubit() : super(const FabState());

  void closeFabGacha() {
    emit(state.copyWith(isGachaPonShowed: false));
  }
}
