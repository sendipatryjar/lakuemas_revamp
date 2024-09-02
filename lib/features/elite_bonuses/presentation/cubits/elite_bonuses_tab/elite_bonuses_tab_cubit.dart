import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'elite_bonuses_tab_state.dart';

class EliteBonusesTabCubit extends Cubit<EliteBonusesTabState> {
  EliteBonusesTabCubit()
      : super(const EliteBonusesTabState(
          enEliteBonusTab: EnEliteBonusTab.tradeBonus,
        ));

  void changeTab(EnEliteBonusTab enEliteBonusTab) {
    emit(state.copyWith(enEliteBonusTab: enEliteBonusTab));
  }
}
