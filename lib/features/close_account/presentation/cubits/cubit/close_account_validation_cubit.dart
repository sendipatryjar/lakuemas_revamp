import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'close_account_validation_state.dart';

class CloseAccountValidationCubit extends Cubit<CloseAccountValidationState> {
  CloseAccountValidationCubit() : super(const CloseAccountValidationState());

  bool get isValid => state.isClsAccError == false;

  void validate(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(
        isClsAccError: true,
        isClsAccErrorMessage: 'Wajib diisi',
      ));
      return;
    }
    emit(state.copyWith(
      isClsAccError: false,
      isClsAccErrorMessage: '',
    ));
  }
}
