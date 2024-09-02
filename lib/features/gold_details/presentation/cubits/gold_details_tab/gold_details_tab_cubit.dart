import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'gold_details_tab_state.dart';

class GoldDetailsTabCubit extends Cubit<GoldDetailsTabState> {
  GoldDetailsTabCubit()
      : super(const GoldDetailsTabState(
            enGoldDetails: EnGoldDetails.goldDetails));

  void changeTab(EnGoldDetails enGoldDetails) =>
      emit(state.copyWith(enGoldDetails: enGoldDetails));
}
