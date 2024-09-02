import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'laku_save_terms_condition_state.dart';

class LakuSaveTermsConditionCubit extends Cubit<LakuSaveTermsConditionState> {
  LakuSaveTermsConditionCubit() : super(const LakuSaveTermsConditionState());

  void updateTermsConditions(bool value) {
    emit(state.copyWith(isTermsConditionsChecked: value));
  }
}
