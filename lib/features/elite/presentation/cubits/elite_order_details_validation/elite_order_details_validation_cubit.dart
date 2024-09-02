import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'elite_order_details_validation_state.dart';

class EliteOrderDetailsValidationCubit
    extends Cubit<EliteOrderDetailsValidationState> {
  EliteOrderDetailsValidationCubit()
      : super(const EliteOrderDetailsValidationState());

  void updateTermsConditions(bool value) =>
      emit(state.copyWith(isTermsConditionsChecked: value));
}
